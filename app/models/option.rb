
class Option < ActiveRecord::Base

  belongs_to :question
  
  validates :body, :presence => true
  
  validates_uniqueness_of :body, :scope => :question_id
end
