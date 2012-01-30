
class Option < ActiveRecord::Base

  belongs_to :question, :inverse_of => :options
  
  validates :body, :presence => true
#  validate :has_body
#  
#  def has_body
#    p "_"*80
#    p self
#    p self.question
#  end
end
