class Subjective < Question
#  has_one :option, :foreign_key => "question_id"
  
#  accepts_nested_attributes_for :option, :allow_destroy => true
  
  before_create :valid_answer
  
  def valid_answer
    errors.add('answers', "can't be blank") and return false if options.empty?
  end
end
