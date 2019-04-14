function _natural_selection_kill_selection --description 'Remove selected content'
  _natural_selection_is_selecting; or return
  commandline --function kill-selection
  _natural_selection_end_selection
  # Otherwise the selection highlighting remains
  commandline --function repaint
end
