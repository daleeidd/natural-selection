function _natural_selection_wrap_selection \
  --description 'Replaces selection with provided content' \
  --argument-names left right

  set --local selection (_natural_selection_get_selection)
  # We are assuming here that left and right have the same length
  set --local inset (string length -- "$left")
  _natural_selection_replace_selection --inset-selection-by $inset -- "$left$selection$right"
end
