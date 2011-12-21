require 'spec_helper'

describe Question do
  before(:each) do
    @valid_attributes = {
      :body => "Question?",
      :category_id => 1,
      :level => 0,
      :admin_id => 2 }
    @question1 = Question.new(@valid_attributes)
  end
  
  it "should create a new instance given valid attributes" do
    q = Question.new(@valid_attributes)
    q.should be_valid
  end
  
  it "should have a body" do
    @question1.should validate_presence_of(:body)
  end
  
  it "should have type" do
    @question1.should validate_presence_of(:ques_type)
  end
  
  it "should have category id" do
    @question1.should validate_presence_of(:category_id)
  end
  
  it "should have level" do
    @question1.should validate_presence_of(:level)
  end
  
  it "should accept nested attributes for answers" do
    @question1.respond_to?('answers=').should be_true
  end
  
  it "should accept nested attributes for options" do
    @question1.respond_to?('options=').should be_true
  end
  
  it "should have many answers" do
    @question1.should have_many(:answers).dependent(:destroy)
  end
  
  it "should have many options" do
    @question1.should have_many(:options).dependent(:destroy)
  end
  
  it "should belong to category" do
    @question1.should belong_to(:category)
  end
  
  it "should belong to admin" do
    @question1.should belong_to(:admin)
  end
  
  it "should save nil for empty provider" do
    valid_attr = {
      :body => "Question 2?",
      :level => 1,
      :category_id => 1,
      :admin_id => 2,
      :provider => "   ",
      :options_attributes => {"1" => { :body => "opt 1"}, "2" => { :body => "opt 2"}},
      :answers_attributes => {"1" => {:body => "opt 1"}}
      }
    question2 = Question.new(valid_attr)
    question2.save
    question2.provider.should == nil
  end
  
  it "should not save nil for valid provider" do
    valid_attr = {
      :body => "Question 2?",
      :level => 1,
      :category_id => 1,
      :admin_id => 2,
      :provider => "provider 1",
      :options_attributes => {"1" => { :body => "opt 1"}, "2" => { :body => "opt 2"}},
      :answers_attributes => {"1" => {:body => "opt 1"}}
      }
    question2 = Question.new(valid_attr)
    question2.save
    question2.provider.should == "provider 1"
  end
  
  it "should have atleast two and atmost four options before creation" do
    ques_attr = {
      :body => "Question 2?",
      :ques_type => "Multiple Choice",
      :level => 1,
      :category_id => 1,
      :admin_id => 2,
      :provider => "provider 1",
      :answers_attributes => {"1" => {:body => "opt 1"}}
    }
    
    question = Question.create(ques_attr)
    question.errors[:options] == 'Atleast two options'
    question.save.should == false
    
    ques_attr[:options_attributes] = {"1" => { :body => "opt 1"}}
    question = Question.create(ques_attr)
    question.errors[:options] == 'Atleast two options'
    question.save.should == false
    
    ques_attr[:options_attributes] = {"1" => { :body => "opt 1"}, "2" => { :body => "opt 2"}}
    question = Question.create(ques_attr)
    question.errors.empty? == true
    question.save.should == true
    
    ques_attr[:options_attributes] = {"1" => { :body => "opt 1"}, "2" => { :body => "opt 2"}, "3" => { :body => "opt 3"}, "4" => { :body => "opt 4"}}
    question = Question.create(ques_attr)
    question.errors.empty? == true
    question.save.should == true
    
    ques_attr[:options_attributes] = {"1" => { :body => "opt 1"}, "2" => { :body => "opt 2"}, "3" => { :body => "opt 3"}, "4" => { :body => "opt 4"}, "5" => { :body => "opt 5"}}
    question = Question.create(ques_attr)
    question.errors[:options] == 'Atleast two options'
    question.save.should == false
  end
  
  it "should have atleast one answer before creation" do
    ques_attr = {
      :body => "Question 2?",
      :ques_type => "Multiple Choice",
      :level => 1,
      :category_id => 1,
      :admin_id => 2,
      :provider => "provider 1",
      :options_attributes => {"1" => { :body => "opt 1"}, "2" => { :body => "opt 2"}}
    }
    
    question = Question.create(ques_attr)
    question.errors[:answers] == "can't be blank"
    question.save.should == false
    
    ques_attr[:answers_attributes] = {"1" => {:body => "opt 1"}}
    question = Question.create(ques_attr)
    question.errors.empty? == true
    question.save.should == true
  end
  
  it "should have valid answer before creation " do
    ques_attr = {
      :body => "Question 2?",
      :ques_type => "Multiple Choice",
      :level => 1,
      :category_id => 1,
      :admin_id => 2,
      :provider => "provider 1",
      :options_attributes => {"1" => { :body => "opt 1"}, "2" => { :body => "opt 2"}},
      :answers_attributes => {"1" => {:body => ""}}
    }
    
    question = Question.create(ques_attr)
    question.errors[:answers] == "is invalid"
    question.save.should == false
  end
  
  it "answers are valid or not, respective to options" do
    options = {"1" => { :body => "opt 1"}, "2" => { :body => "opt 2"}, "3" => { :body => "opt 3"}, "4" => { :body => "opt 4"}}
    answers = {"1" => {:body => ""}}
    @question1.valid_answer?(answers, options).should == false
    
    answers = {"1" => {:body => "opt_invalid"}}
    @question1.valid_answer?(answers, options).should == false
    
    answers = {"1" => {:body => "opt 1"}}
    @question1.valid_answer?(answers, options).should == true
    
    options = {"1" => { :body => ""}, "2" => { :body => ""}, "3" => { :body => ""}, "4" => { :body => ""}}
    answers = {"1" => {:body => ""}}
    @question1.valid_answer?(answers, options).should == false
  end
  
  it "atleast two options or not" do
    options = {"1" => { :body => "opt 1"}}
    @question1.atleast_two_options?(options).should == nil
    
    options = {"1" => { :body => "opt 1"}, "2" => { :body => "opt 2"}}
    @question1.atleast_two_options?(options).should == true
    
    options = {"1" => { :body => "opt 1"}, "2" => { :body => ""}}
    @question1.atleast_two_options?(options).should == nil
  end
  
  it "question_tags" do
    valid_attr = {
      :body => "Question 2?",
      :level => 1,
      :category_id => 1,
      :admin_id => 2,
      :provider => "provider 1",
      :answers_attributes => {"1" => {:body => "opt 1"}}
    }
    q = Question.new(valid_attr)
    q.tag_list = "js, css"
    q.save
    
    Question.question_tags("s").should == [{"name"=>"js", "value"=>"js"}, {"name"=>"css", "value"=>"css"}]
    Question.question_tags("j").should == [{"name"=>"js", "value"=>"js"}]
    Question.question_tags("a").should == []
  end
  
  it "get questions by tags" do
    valid_attr = {
      :body => "Question 2?",
      :level => 1,
      :category_id => 1,
      :admin_id => 2,
      :provider => "provider 1",
      :answers_attributes => {"1" => {:body => "opt 1"}}
    }
    q = Question.new(valid_attr)
    q.tag_list = "js, css"
    q.save
    
    valid_attr = {
      :body => "Question 3?",
      :level => 1,
      :category_id => 1,
      :admin_id => 2,
      :provider => "provider 2",
      :answers_attributes => {"1" => {:body => "opt 1"}}
    }
    q = Question.new(valid_attr)
    q.tag_list = "js"
    q.save
    
    valid_attr = {
      :body => "Question 4?",
      :level => 1,
      :category_id => 1,
      :admin_id => 2,
      :provider => "provider 3",
      :answers_attributes => {"1" => {:body => "opt 1"}}
    }
    q = Question.new(valid_attr)
    q.tag_list = "css"
    q.save
    
    Question.get_ques_by_tags("js").length.should == 2
    Question.get_ques_by_tags("css").length.should == 2
    Question.get_ques_by_tags("js,css").length.should == 3
  end
  
end
