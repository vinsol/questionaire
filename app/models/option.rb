
class Option < ActiveRecord::Base

  belongs_to :question
  
  validates :body, :presence => true
  
  def self.options_shuffle(question)
    question.options.shuffle.sort_by{rand}.shuffle
  end
end
