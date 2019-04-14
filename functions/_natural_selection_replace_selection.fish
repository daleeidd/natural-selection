function _natural_selection_replace_selection --description 'Replaces selection with provided content'
  # Get arguments
  set --local options (fish_opt --short i --long inset-selection-by --long-only --required-val)
  argparse --name '_natural_selection_replace_selection' $options -- $argv
  set --local replacement "$argv"

  # Required parameters
  if test -z "$replacement"
    _natural_selection_end_selection
    return
  end

  # Pass through if not selecting
  if not _natural_selection_is_selecting
    # Quote and -- just in case
    commandline --insert -- "$replacement"
    return
  end

  # Get select beginning and end. We need to account for selection direction
  set --local selection_left_edge 0
  set --local selection_right_edge 0
  set --local cursor_position (commandline --cursor)
  if test "$cursor_position" -gt "$_natural_selection_selection_start"
    set selection_left_edge $_natural_selection_selection_start
    set selection_right_edge $cursor_position
  else
    set selection_left_edge $cursor_position
    set selection_right_edge $_natural_selection_selection_start
    set should_swap_cursor "true"
  end

  # Get before and after selection so we can replace the entire commandline
  set --local buffer (commandline --current-buffer)
  set --local head (string sub --length $selection_left_edge -- "$buffer")
  set --local tail (string sub --start (math $selection_right_edge + 1) -- "$buffer")
  # Replace commandline with new selection. Quote and -- just in case
  commandline --replace -- "$head$replacement$tail"

  # Support wrapping libaries (eg. wrapping selection in quotes)
  if test -n "$_flag_inset_selection_by"
    # Selection can go in either direction so it is easier to use selection length when reselecting
    set --local selection_length (math (string length -- "$replacement") - $_flag_inset_selection_by \* 2)
    set --local new_selection_start $selection_left_edge
    set --local input_function 'forward-char'
    if set --query should_swap_cursor
      set new_selection_start $selection_right_edge
      set input_function 'backward-char'
    end
    set new_selection_start (math $new_selection_start + $_flag_inset_selection_by)

    # Reset the selection to begin at start of inset
    _natural_selection_end_selection
    commandline --cursor $new_selection_start
    _natural_selection_begin_selection

    # Create new selection using same method as user. This is the only approach I could get working. Setting the cursor
    # to grow the selection does paint the selection, but none of the input functions like kill-selection recognise the
    # painted contents as selected
    while test $selection_length -gt 0
      commandline --function $input_function
      set selection_length (math $selection_length - 1)
    end

    commandline --function repaint
  else
    # Set cursor to end of replacement
    commandline --cursor (math $selection_left_edge + (string length -- "$replacement"))
    _natural_selection_end_selection
    commandline --function repaint
  end
end
