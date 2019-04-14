function _natural_selection --description 'Input wrapper to improve selection'
  # Get arguments
  set --local options (fish_opt --short s --long is-selecting)
  set options $options (fish_opt --short c --long is-character)
  argparse --name '_natural_selection' $options -- $argv

  # $argv can be either depending on flag
  set --local input_function $argv
  set --local character $argv

  function _should_swap_cursor --no-scope-shadowing
    set --local cursor_position (commandline --cursor)
    switch $input_function
      case 'forward-char' 'end-*'
        test "$cursor_position" -lt $_natural_selection_selection_start
      case 'backward-char' 'beginning-*'
        test "$cursor_position" -gt $_natural_selection_selection_start
    end
  end

  function _is_kill_input_function --no-scope-shadowing
    string match --quiet --regex 'kill|delete' $input_function
  end

  function _is_clipboard_input_function --no-scope-shadowing
    string match --quiet '*-to-clipboard' $input_function
  end

  function _is_native_input_function --no-scope-shadowing
    not string match --quiet '*-clipboard' $input_function
  end

  function _is_cut_input_function --no-scope-shadowing
    string match --quiet 'cut-*' $input_function
  end

  function _is_single_character_input_function --no-scope-shadowing
    string match --quiet '*-char' $input_function
  end

  # If not cleared here, then logic further down will cause the cursor to get stuck. It would be nicer if we could do
  # this right after an input function, but the cursor position fetched from --cursor doesn't get updated quick enough.
  if _natural_selection_is_selecting
    if test (commandline --cursor) -eq $_natural_selection_selection_start
      _natural_selection_end_selection
      commandline --function force-repaint
    end
  end

  if test -n "$_flag_is_character"
    # Killing and inserting doesn't work well. Quote and -- just in case
    _natural_selection_replace_selection -- "$character"
    _natural_selection_end_selection
  else if test -n "$_flag_is_selecting"
    _natural_selection_begin_selection
    commandline --function $input_function
  else if not _natural_selection_is_selecting; and _is_native_input_function
    # Pass through. Keep this high for performance
    commandline --function $input_function
  else if string match --quiet 'paste-from-clipboard' $input_function
    _natural_selection_replace_selection -- (pbpaste)
  else if _natural_selection_is_selecting
    if _is_kill_input_function
      _natural_selection_kill_selection
    else if _is_clipboard_input_function
      _natural_selection_get_selection | pbcopy
      if _is_cut_input_function
        _natural_selection_kill_selection
      end
    else
      if _should_swap_cursor
        commandline --function swap-selection-start-stop
      end
      _natural_selection_end_selection

      if not _is_single_character_input_function
        commandline --function $input_function
      end

      # Ensure that commandline reflects selection
      commandline --function force-repaint
    end
  end
end
