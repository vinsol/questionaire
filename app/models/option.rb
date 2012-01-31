
class Option < ActiveRecord::Base

  belongs_to :question
  
  validates :body, :presence => true#, :if => Proc.new {|a| p self; true}
#  before_save :has_body
#  validate :has_body
  
#  def has_body
#    p "_"*80
#    p self
#    p self.question
#  end
end
