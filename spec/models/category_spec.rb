require 'spec_helper'

describe Category do
  before(:each) do
    @valid_attributes = {
      :name => "IOS"
    }
    @category = Category.new(@valid_attributes)
  end
  
  it "should belong to question" do
    @category.should have_many(:questions).dependent(:destroy)
  end
  
end
