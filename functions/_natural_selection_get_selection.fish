function _natural_selection_get_selection --description 'Echoes the selection'
  # Pass through if not selecting
  _natural_selection_is_selecting; or return

  # Get selection beginning and end
  set --local selection_start 0
  set --local selection_end 0
  set --local cursor_position (commandline --cursor)

  if test "$cursor_position" -ge "$_natural_selection_selection_start"
    set selection_start $_natural_selection_selection_start
    set selection_end $cursor_position
  else
    set selection_start $cursor_position
    set selection_end $_natural_selection_selection_start
  end

  # Fish indices are 1-based, but cursor is 0-based
  set selection_start (math $selection_start + 1)
  set selection_end (math $selection_end + 1)

  set --local selection_length (math $selection_end - $selection_start)
  set --local buffer (commandline --current-buffer)
  #
  echo -ns -- (string sub --start $selection_start --length $selection_length -- "$buffer")
end
