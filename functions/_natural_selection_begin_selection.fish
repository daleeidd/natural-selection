function _natural_selection_begin_selection --description 'Begins selection'
  _natural_selection_is_selecting; and return
  commandline --function begin-selection
  # We need to track this ourselves since the selection is not exposed to the fish environment.
  set --global _natural_selection_selection_start (commandline --cursor)
end
