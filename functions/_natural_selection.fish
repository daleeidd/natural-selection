function _natural_selection --description 'Input wrapper to improve selection'
  # Get arguments
  set --local options (fish_opt --short s --long is-selecting)
  argparse --name '_natural_selection' $options -- $argv

  set --local input_function $argv

  function _should_swap_cursor --no-scope-shadowing
    set --local cursor_position (commandline --cursor)
    switch $input_function
      case 'forward-char' 'end-of-*'
        test "$cursor_position" -lt $_natural_selection_selection_start
      case 'backward-char' 'beginning-of-*'
        test "$cursor_position" -gt $_natural_selection_selection_start
      case '*'
        false
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

  function _is_normal_function --no-scope-shadowing
    functions --query $input_function
  end

  function _is_cut_input_function --no-scope-shadowing
    string match --quiet 'cut-*' $input_function
  end

  function _is_single_character_input_function --no-scope-shadowing
    string match --quiet '*-char' $input_function
  end

  function _call_input_function --no-scope-shadowing
    if _is_normal_function
      $input_function
    else
      commandline --function $input_function
    end
  end

  # It's possible to get into a state where we think we're selecting but there's no actual selection:
  # - Selecting "into" the start/end of the buffer. e.g. Shift+RightArrow at the end of the buffer (starts selection but nothing gets selected).
  # - When the generic binding is hit (bind '') during a selection. We don't call _natural_selection for the generic binding, so _natural_selection_is_selecting will return 0 (true) even though the selection has been ended in fish.
  # In these cases, the cursor will seem to get stuck because we skip cursor movement input functions when ending the selection.
  # To resolve this, we end the selection if the actual selection is empty.
  if _natural_selection_is_selecting
    if test -z (commandline --current-selection)
      _natural_selection_end_selection
      commandline --function force-repaint
    end
  end

  if test -n "$_flag_is_selecting"
    _natural_selection_begin_selection
    _call_input_function
  else if not _natural_selection_is_selecting; and _is_native_input_function
    # Pass through. Keep this high for performance
    _call_input_function
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

      # When ending the selection, the cursor should not move
      if not _is_single_character_input_function
        _call_input_function
      end

      # Ensure that commandline reflects selection
      commandline --function force-repaint
    end
  end
end
