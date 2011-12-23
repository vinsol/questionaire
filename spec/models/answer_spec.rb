require 'spec_helper'

describe Answer do
  before(:each) do
    @valid_attributes = {
      :body => "Answer 1",
      :question_id => 12
    }
    @answer1 = Answer.new(@valid_attributes)
  end
  
  it "should belong to question" do
    @answer1.should belong_to(:question)
  end
  
end
