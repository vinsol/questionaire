class QuestionsController < ApplicationController
  
  before_filter :admin_signed_in
  before_filter :get_question_by_id, :only => [:show, :edit, :update, :destroy]
  
  def index
    @questions = Question.paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 5
  end

  def show
    
  end


  def new
    @question = Question.new
    @type = @question.ques_type
  end


  def edit
    @type = @question.ques_type
  end


  def create
    @question = Question.new(params[:question])
    @question.admin_id = session[:admin_id]
    @question.tag_list = params[:as_values_tags]
    
    if @question.save
      redirect_to(@question, :notice => 'Question was successfully created.')
    else
      @type = params[:question][:ques_type] 
      render :action => "new"
    end
  end
    
    
  def update
    
    @question.admin_id = session[:admin_id]
    @question.tag_list = params[:as_values_tags]
    
    unless (@question.atleast_two_options?(params[:question][:options_attributes]))
     flash[:option_error] = 'Atleast two and atmost four options are valid'
    end

    unless (@question.valid_answer?(params[:question][:answers_attributes], params[:question][:options_attributes]))
     flash[:answer_error] = ' not valid'
    end
    
#    if @question.update_attributes(params[:question])
    if flash[:option_error].blank? && flash[:answer_error].blank? && @question.update_attributes(params[:question])
      redirect_to(@question, :notice => 'Question was successfully updated.') 
    else
      @type = params['question']['ques_type']
      render :action => "edit" 
    end
  end



  def destroy
    @question.destroy
    redirect_to(questions_url) 
  end
  

  def tags_index
    @questions = Question.tagged_with(params[:name]).paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 5
  end
  

  def level_index
    @questions = Question.where("level = ?",params[:id]).paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 5
  end
  
  def category_index
    @questions = Question.where("category_id = ?",params[:id]).paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 5
  end

  def make_test
    
  end
  

  def show_fetch_ques
    @question = Question.find(params[:id])
    render :partial => "show_fetch_ques"
  end
  
  
  # Optomize
  def fetch_questions
    ques = Question.get_ques_by_tags(params[:as_values_tags])
    @questions = Question.search(ques, params[:type], params[:category_id], params[:level])
  end
  

  def change_answer_div
    @question = Question.where(" id = (?)", params[:id]).first unless params[:id].blank?
    if params['type'] == "Multiple Choice"
      @ajax_data = "multiple_choice"
    elsif params['type'] == "Multiple Choice/Answer"
      @ajax_data = "multiple_choice_answer"
    elsif params['type'] == "Subjective"
      @ajax_data = "subjective"
    end
  end
  

  def ques_tags
    data = Question.question_tags(params[:q])
		respond_to do |format|			
			format.html{}
			format.js{
				render :json => data
			}			
		end
  end
  

  def download
    name = params[:test_name]
    # Move in model
    unless FileTest.exists?("temp_test/"+name+'.zip')
      Question.download(name)
      send_file 'temp_test/'.+name+'.zip'
    else
      send_file 'temp_test/'.+name+'.zip'
    end
  end
  
  #search by text of question
  def show_search
    unless(params[:text].empty?)
      @questions = Question.where("body like '%#{params[:text]}%'").paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 5
    else
      @questions = Question.paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 5
    end
  end

  private
  
  def get_question_by_id
    @question = Question.where("id = (?)",params[:id]).first
  end
  
end
