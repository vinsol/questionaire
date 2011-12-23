require 'spec_helper'

describe Admin do
  before(:each) do
    @valid_attributes = {
      :email => "sample@vinsol.com"
    }
    @admin1 = Admin.new(@valid_attributes)
  end
  
  it "should validate uniqueness of email" do
    valid_attr = { :email => "sample@vinsol.com" }
    admin2 = Admin.create(valid_attr)
    @admin1.should validate_uniqueness_of(:email).with_message("Admin has already been created")
  end
  
  it "should validate format of email" do
    invalid_attr = { :email => "sample@example.com" }
    admin = Admin.new(invalid_attr)
    admin.should_not be_valid
    admin.should have(1).error_on(:email)
    
    valid_attr = { :email => "sample@vinsol.com" }
    admin = Admin.new(valid_attr)
    admin.should be_valid
  end
  
  it "should have many questions" do
    @admin1.should have_many(:questions)
  end
  
end
