require 'spec_helper'

describe QuestionsController do
  render_views
  
  before do
    @valid_attributes = {:body => "Question 1?",:level => 1,:category_id => 1,:provider => "provider 1",:answers_attributes => {"1" => {:body => "ans 1"}},:ques_type => "Subjective"}
    
    @question1 = mock_model(Question, :save => true, :id => 1, :body => "Question 1?", :level => 1, :category_id => 1, :admin_id => 1, :provider => "provider 2", :answers_attributes => {"1" => {:body => "ans 1"}}, :ques_type => "Subjective")
    @admin = mock_model(Admin, :save => true, :id => 1, :name => "priyank", :email => "admin@vinsol.com")
    @questions = [@question1]
    
    @category = mock_model(Category, :save => true, :name => "IOS")
    @answer = mock_model(Answer, :save => true, :body => "Answer 1")
    
    @question1.stub!(:category).and_return(@category)
    @question1.stub!(:tag_list).and_return(["js","css"])
    @question1.stub!(:answers).and_return([@answer])
    @questions.stub!(:total_pages).and_return(1)
    Admin.stub!(:where).and_return([@admin]).stub!(:first).and_return(@admin).stub!(:name).and_return("priyank")
    controller.stub!(:admin_signed_in).and_return(@admin)
  end
  
  describe "GET new" do
    it "assigns a new question as @question" do
     
     get :new
     response.should be_success
     assigns(:question).should be_a_new(Question)
     assigns(:type).should eq("Subjective")
     response.should render_template("new")
    end
  end
  
  describe "GET index" do
    it "assigns all questions as @questions" do

      @question1.category.stub!(:name).and_return("IOS")
      Question.should_receive(:paginate).with(:page => nil, :order => 'updated_at DESC', :per_page => 5).and_return(@questions)
      
      get :index
      assigns(:questions).should eq(@questions)
      response.should be_success
      response.should render_template("index")
    end
  end
  
  describe "GET Show" do
    it "assigns the requested question as @question" do
      
      @question1.category.stub!(:name).and_return("IOS")
      Question.should_receive(:where).and_return([@question1]).stub!(:first).and_return(@question1)
      
      get :show, :id => @question1.id
      assigns(:question).should eq(@question1)
      response.should be_success
      response.should render_template("show")
    end
  end
  
  describe "GET edit" do
    it "assigns the requested question as @question" do
      
      Question.should_receive(:where).and_return([@question1]).stub!(:first).and_return(@question1)
      
      get :edit, :id => @question1.id
      assigns(:question).should eq(@question1)
      assigns(:type).should eq("Subjective")
    end
  end
  
  describe "POST Create" do
    describe "with valid params" do
      it "creates a new Question" do
        session[:admin_id] = 1
        expect {
        post :create, :question => @valid_attributes
        }.to change(Question, :count).by(1)
      end

      it "assigns a newly created question as @question" do
        session[:admin_id] = 1
        post :create, :question => @valid_attributes
        assigns(:question).should be_a(Question)
        assigns(:question).should be_persisted
      end

      it "redirects to the created article" do
        session[:admin_id] = 1
        post :create, :question => @valid_attributes
        response.should redirect_to(Question.last)
        flash[:notice].should eq('Question was successfully created.')
      end
      
      it "creates the nested attributes with it" do
        session[:admin_id] = 1
        expect {
        post :create, :question => @valid_attributes
        }.to change(Answer, :count).by(1)
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved question as @question" do

        Question.any_instance.stub(:save).and_return(false)
        post :create, :question => {}
        assigns(:question).should be_a_new(Question)
      end

      it "re-renders the 'new' template" do

        Question.any_instance.stub(:save).and_return(false)
        post :create, :question => {}
        response.should render_template("new")
      end
    end
  end
  
  describe "PUT update" do
    describe "with valid params" do
      it "assigns expected question to @question, updates the requested question and redirects to the question" do
        
        @valid_attributes[:admin_id] = 1
        question = Question.create!(@valid_attributes)
        
        session[:admin_id] = 2
        valid_attr = {"body" => "Question 10?", "level" => 2, "category_id" => 2, "ques_type" => "Subjective", "answers_attributes" => {"1" => {"body" => "ans", "id" => question.answers.first.id}} }
        
        Question.should_receive(:where).and_return([question]).stub!(:first).and_return(question)
        
        ques = Question.find(question.id)
        ques.stub!(:update_attributes).with(valid_attr)
        
        put :update, :id => question.id, :question => valid_attr
        
        assigns(:question).should eq(question)
        question.body.should eq("Question 10?")
        response.should redirect_to(question)
        flash[:notice].should eq('Question was successfully updated.')
      end
      
      it "updates the nested attributes with it" do
        @valid_attributes[:admin_id] = 1
        question = Question.create!(@valid_attributes)
        
        session[:admin_id] = 2
        valid_attr = {"body" => "Question 10?", "level" => 2, "category_id" => 2, "ques_type" => "Subjective", "answers_attributes" => {"1" => {"body" => "ans", "id" => question.answers.first.id}} }
        
        Question.should_receive(:where).and_return([question]).stub!(:first).and_return(question)
        
        ques = Question.find(question.id)
        ques.stub!(:update_attributes).with(valid_attr)
        
        put :update, :id => question.id, :question => valid_attr
        question.answers.first.body.should eq("ans")
      end
    end
    
    describe "with invalid params" do
      it "assigns the question as @question, dosen't updates the question and re-renders edit" do
        @valid_attributes[:admin_id] = 1
        question = Question.create!(@valid_attributes)
        
        session[:admin_id] = 2
        invalid_attr = {"body" => "Question 10?", "level" => 2, "category_id" => 2, "ques_type" => "Subjective", "answers_attributes" => {"1" => {"body" => "", "id" => question.answers.first.id}} }
        
        Question.should_receive(:where).and_return([question]).stub!(:first).and_return(question)
        
        ques = Question.find(question.id)
        ques.stub!(:update_attributes).with(invalid_attr)
        
        put :update, :id => question.id, :question => invalid_attr
        
        assigns(:question).should eq(question)
        question.body.should_not eq("Question 10?")
        
        assigns(:type).should eq(invalid_attr["ques_type"])
        response.should render_template("edit")
        flash[:answer_error].should eq(' not valid')
      end
    end
  end
  
  describe "DELETE destroy" do
    it "destroys the requested article" do
      @valid_attributes[:admin_id] = 1
      question = Question.create!(@valid_attributes)
      expect {
        delete :destroy, :id => question.id
      }.to change(Question, :count).by(-1)
    end

    it "redirects to the articles list" do
      @valid_attributes[:admin_id] = 1
      question = Question.create!(@valid_attributes)
      delete :destroy, :id => question.id
      response.should redirect_to(questions_url)
    end
  end
  
  describe "GET tags_index" do
    it "assigns questions with a particular tag to @questions and render tags_index" do
      @valid_attributes[:admin_id] = 1
      question1 = Question.new(@valid_attributes)
      question1.tag_list = "css"
      question1.save
      question2 = Question.new(@valid_attributes)
      question2.tag_list = "js"
      question2.save
      
      Question.any_instance.stub(:category).and_return(@category).stub!(:name).and_return("IOS")
      
      get :tags_index, :name => "js"
      assigns(:questions).should eq([question2])
      response.should render_template("tags_index")
      
      get :tags_index, :name => "css"
      assigns(:questions).should eq([question1])
      response.should render_template("tags_index")
    end
  end
  
  describe "GET level_index" do
    it "assigns questions with a particular tag to @questions and render level_index" do
      @valid_attributes[:admin_id] = 1
      question1 = Question.create!(@valid_attributes)
      @valid_attributes[:level] = 2
      question2 = Question.create!(@valid_attributes)
      
      Question.any_instance.stub(:category).and_return(@category).stub!(:name).and_return("IOS")
      
      get :level_index, :id => "1"
      assigns(:questions).should eq([question1])
      response.should render_template("level_index")
      
      get :level_index, :id => "2"
      assigns(:questions).should eq([question2])
      response.should render_template("level_index")
    end
  end
  
  describe "GET category_index" do
    it "assigns questions with a particular tag to @questions and render level_index" do
      @valid_attributes[:admin_id] = 1
      question1 = Question.create!(@valid_attributes)
      @valid_attributes[:category_id] = 2
      question2 = Question.create!(@valid_attributes)
      Category.stub!(:find).and_return(@category).stub!(:name).and_return("IOS")
      Question.any_instance.stub(:category).and_return(@category).stub!(:name).and_return("IOS")
      
      get :category_index, :id => "1"
      assigns(:questions).should eq([question1])
      response.should render_template("category_index")
      
      get :category_index, :id => "2"
      assigns(:questions).should eq([question2])
      response.should render_template("category_index")
    end
  end
  
  describe "GET make_test" do
    it "should render make_test" do
      get :make_test
      response.should be_success
      response.should render_template("make_test")
    end
  end
  
  describe "GET show_fetch_ques" do
    it "should assign questions to @questions" do
      @valid_attributes[:admin_id] = 1
      question = Question.create!(@valid_attributes)
      Question.any_instance.stub(:category).and_return(@category).stub!(:name).and_return("IOS")
      get :show_fetch_ques, :id => question.id
      assigns(:question).should eq(question)
    end
    
    it "should render partial show_fetch_ques" do
      @valid_attributes[:admin_id] = 1
      question = Question.create!(@valid_attributes)
      Question.any_instance.stub(:category).and_return(@category).stub!(:name).and_return("IOS")
      get :show_fetch_ques, :id => question.id
      response.should render_template("show_fetch_ques")
    end
  end
  
  describe "xhr GET fetch_questions" do
    it "should assign fetched questions by their respective category, tags, level and type to @questions" do
      @valid_attributes[:admin_id] = 1
      question1 = Question.new(@valid_attributes)
      question1.tag_list = "js,css"
      question1.save
      @valid_attributes[:level] = 2 
      question2 = Question.create!(@valid_attributes)
      @valid_attributes[:category_id] = 2
      question3 = Question.create!(@valid_attributes)
      
      params = {"name"=>"sample_test", "instructions"=>"example", "as_values_tags"=>"", "category_id"=>"1", "level"=>{"0"=>"", "1"=>"", "2"=>""}, "sets"=>"2"}
      xhr :get, :fetch_questions, params
      assigns(:questions).should eq([question1, question2])
      response.should render_template("fetch_questions")
      response.should render_template(:partial => "_show_fetched_questions")
      
      params = {"name"=>"sample_test", "instructions"=>"example", "as_values_tags"=>"", "category_id"=>"2", "level"=>{"0"=>"", "1"=>"", "2"=>"4"}, "sets"=>"2"}
      xhr :get, :fetch_questions, params
      assigns(:questions).should eq([question3])
      response.should render_template("fetch_questions")
      response.should render_template(:partial => "_show_fetched_questions")
      
      params = {"name"=>"sample_test", "instructions"=>"example", "as_values_tags"=>"js,html", "category_id"=>"1", "level"=>{"0"=>"", "1"=>"2", "2"=>"4"}, "sets"=>"2"}
      xhr :get, :fetch_questions, params
      assigns(:questions).should eq([question1])
      response.should render_template("fetch_questions")
      response.should render_template(:partial => "_show_fetched_questions")
    end
  end
  
  describe "xhr GET change_answer_div" do
    describe "when the question is not new" do
      it "should assign question to @question and respective type to @ajax_data" do
        @valid_attributes[:admin_id] = 1
        question = Question.create!(@valid_attributes)
        params = {"type" => "Subjective", "id" => question.id}
        xhr :get, :change_answer_div, params
        assigns(:question).should eq(question)
        assigns(:ajax_data).should eq("subjective")
      end
      
      it "should not assign question to @question" do
        @valid_attributes[:admin_id] = 1
        question = Question.create!(@valid_attributes)
        params = {"type" => "Subjective"}
        xhr :get, :change_answer_div, params
        assigns(:question).should eq(nil)
        assigns(:ajax_data).should eq("subjective")
      end
      
      it "should render template change_answer_div and partial as the value of @ajax_data" do
        @valid_attributes[:admin_id] = 1
        question = Question.create!(@valid_attributes)
        params = {"type" => "Subjective", :id => question.id}
        xhr :get, :change_answer_div, params
        response.should render_template("change_answer_div")
        response.should render_template(:partial => "_subjective")
      end
    end
    
    describe "when the question is new" do
      it "should not assign question to @question" do
        @valid_attributes[:admin_id] = 1
        question = Question.create!(@valid_attributes)
        params = {"type" => "Subjective"}
        xhr :get, :change_answer_div, params
        assigns(:question).should eq(nil)
        assigns(:ajax_data).should eq("subjective")
      end
      
      it "should render template change_answer_div and partial as the value of @ajax_data" do
        @valid_attributes[:admin_id] = 1
        question = Question.create!(@valid_attributes)
        params = {"type" => "Subjective", :id => question.id}
        xhr :get, :change_answer_div, params
        response.should render_template("change_answer_div")
        response.should render_template(:partial => "_subjective")
      end
    end
  end
  
#  describe "GET download" do
#    describe "if zipfile exists" do
#      it "should download the sets" do
#        Question.should_receive(:download)
##        controller.stub!(:send_file).and_return(controller.render :nothing => true)
#        get :download, :test_name => "sample_test"
#        response.should be_success
#      end
#    end
#  end

  describe "xhr GET show_search" do
    describe "has any text" do
      it "should assign questions with body matching to the text to @questions" do
        @valid_attributes[:admin_id] = 1
        @valid_attributes[:body] = "This is the question with text sample ?"
        question1 = Question.create!(@valid_attributes)
        @valid_attributes[:body] = "This is the question with text example ?"
        question2 = Question.create!(@valid_attributes)
        Question.any_instance.stub(:category).and_return(@category).stub!(:name).and_return("IOS")
        
        xhr :get, :show_search, :text => "samp"
        assigns(:questions).should eq([question1])
        
        xhr :get, :show_search, :text => "examp"
        assigns(:questions).should eq([question2])
      end
      
      it "should not assign questions without body matching to the text to @questions" do
        @valid_attributes[:admin_id] = 1
        @valid_attributes[:body] = "This is the question with text sample ?"
        question1 = Question.create!(@valid_attributes)
        @valid_attributes[:body] = "This is the question with text example ?"
        question2 = Question.create!(@valid_attributes)
        Question.any_instance.stub(:category).and_return(@category).stub!(:name).and_return("IOS")
        
        xhr :get, :show_search, :text => "demo"
        assigns(:questions).should be_empty
      end
    end
    
    describe "do not have any text" do
      it "should assign all questions to @questions" do
        @valid_attributes[:admin_id] = 1
        @valid_attributes[:body] = "This is the question with text sample ?"
        question1 = Question.create!(@valid_attributes)
        @valid_attributes[:body] = "This is the question with text example ?"
        question2 = Question.create!(@valid_attributes)
        Question.any_instance.stub(:category).and_return(@category).stub!(:name).and_return("IOS")
        
        xhr :get, :show_search, :text => ""
        assigns(:questions).should eq([question1, question2])
      end
    end
    
    it "should render template show_search and partial showing_fetch_ques" do
      xhr :get, :show_search, :text => ""
      response.should be_success
      response.should render_template("show_search")
      response.should render_template(:partial => "_showing_fetch_ques")
    end
  end
end
