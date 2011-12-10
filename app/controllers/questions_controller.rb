class QuestionsController < ApplicationController
  
  before_filter :admin_signed_in
  before_filter :get_question_by_id, :only => [:show, :edit, :update, :destroy]
  
  def index
    @questions = Question.all
    
  end

  def show
    
  end

  ### Question -> ques_type => "Subjective" in migration
  ### Put choices for ques_type in constant
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

    unless (Question.atleast_two_options?(params[:question][:options_attributes]))
      flash[:option_error] = 'Atleast two and atmost four options are valid'
    end
    
    unless (Question.valid_answer?(params[:question][:answers_attributes], params[:question][:options_attributes]))
      flash[:answer_error] = ' not valid'
    end
    
    if flash[:option_error].blank? && flash[:answer_error].blank? && @question.save
      redirect_to(@question, :notice => 'Question was successfully created.')
    else
      @type = params[:question][:ques_type] 
      render :action => "new"
    end
  end
    
    
  def update
    
    @question.admin_id = session[:admin_id]
    @question.tag_list = params[:as_values_tags]

    unless (Question.atleast_two_options?(params[:question][:options_attributes]))
      flash[:option_error] = 'Atleast two and atmost four options are valid'
    end
    
    unless (Question.valid_answer?(params[:question][:answers_attributes], params[:question][:options_attributes]))
      flash[:answer_error] = ' not valid'
    end
    
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
  
  def change_answer_div
    @question = Question.find(params[:id]) unless params[:id].blank?
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
  
  private
  
  def get_question_by_id
    @question = Question.find(params[:id])
  end
  
end
