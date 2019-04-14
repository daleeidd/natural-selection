function _natural_selection_end_selection --description 'Ends selection'
  _natural_selection_is_selecting; or return
  commandline --function end-selection
  # We need to track this ourselves since the selection is not exposed to the fish environment.
  set --global _natural_selection_selection_start -1
end
