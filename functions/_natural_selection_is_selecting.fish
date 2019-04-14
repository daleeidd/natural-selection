function _natural_selection_is_selecting --description 'Is there an active selection?'
  # We need to track this ourselves since the selection is not exposed to the fish environment.
  set --global --query _natural_selection_selection_start
  and test "$_natural_selection_selection_start" -ne -1
end
