class Subjective < Question

  ## Do they need to be in seperate classes?  
  acts_as_taggable
  acts_as_taggable_on :tags
end
