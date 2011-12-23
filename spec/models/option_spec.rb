require 'spec_helper'

describe Option do
  before(:each) do
    @valid_attributes = {
      :body => "Option 1",
      :question_id => 12
    }
    @option1 = Option.new(@valid_attributes)
  end
  
  it "should belong to question" do
    @option1.should belong_to(:question)
  end
  
end
