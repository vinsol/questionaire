class MultipleChoice < Question
  
  before_create :atleast_two_options
  before_create :valid_answer
  
  def atleast_two_options
    if !(Question::OPTIONS_RANGE[:min]..Question::OPTIONS_RANGE[:max]).include?(options.length)
      errors.add('options', 'Atleast two options')
      return false 
    end
  end
  
  def valid_answer
    errors.add('answers', "can't be blank") and return false if options.empty?
    ans_temp = 0
    # Why are u checking == true
    options.each { |opt| ans_temp += 1 if opt.answer }
    if ans_temp != 1
      errors.add('answers', 'is invalid') 
      return false
    end
  end
  
end
