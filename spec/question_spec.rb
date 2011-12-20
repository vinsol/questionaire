require 'spec_helper'

describe 'Question' do
  before(:each) do
    @valid_attributes = {
      :body => "question?",
      :ques_type => "Subjective" }
    @user1 = User.new(@valid_attributes)
  end
end
