require 'spec_helper'

describe AdminsController do
  render_views
  
  before do
    
    @admin = mock_model(Admin, :save => true, :id => 1, :email => "admin@vinsol.com")
#    @admins = [@admin]
    
    # @comment = mock_model(Comment, :article_id => @article.id)
    # @comments = [@comment]
    # @article.stub!(:comments).and_return(@comments)
    
#    @admin = mock_model(Admin, :id => 1, :username => 'admin', :email => "admin@example.com", 
#    :password => "password", :password_confirmation => "password")
    
#    controller.stub!(:admin_signed_in).and_return(@admin)
  end
  
  describe "GET new" do
    it "assigns a new admin as @admin" do
     get :new
     response.should be_success
     assigns(:admin).should be_a_new(Admin)
     response.should render_template("new")
    end
  end
  
  describe "CREATE" do
    
    it "should successfully create a record" do
      valid_attr = { :admin => {:email => "hi@vinsol.com" }}
      a = mock_model(Admin, valid_attr)
      
      Admin.stub!(:new).and_return(a)
      a.stub!(:save).and_return(true)
      
      Notifier.stub!(:deliver_contact)
#      response.should be_success
#      xhr :create, valid_attr
      post :create, valid_attr
      response.should redirect_to admin_path(a)
#      flash[:notice].should == 'Article was successfully created.'
    end
    
    it "should not create a record" do
      invalid_attr = {:admin => {:email => "admin@example.com"}}
      b = mock_model(Admin, :email  => "admin@example.com")
      
      Admin.stub(:new).and_return(b)
      b.stub(:save).and_return(false)

      post :create, invalid_attr
      response.should render_template(:action => "new")
      response.should be_success
    end
  end
  
  describe "SHOW" do
    
    it "should find a record and render show template" do
      Admin.stub!(:find).and_return(@admin)
      get :show, :id => 1
      response.should be_success
      response.should render_template("show")
    end
  end
  
end
