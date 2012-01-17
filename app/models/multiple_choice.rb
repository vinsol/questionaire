class MultipleChoice < Question
  
  acts_as_taggable
  acts_as_taggable_on :tags
end
