class QuestionsController < ApplicationController
  
  before_filter :admin_signed_in
  before_filter :get_question_by_id, :only => [:show, :edit, :update, :destroy]
  
  def index
    @questions = Question.all
  end

  def show

  end

  def new
    @question = Question.new
  end

  def edit
    @type = @question.ques_type
  end

  def create
    params[:question][:category_id] = params[:question][:category_id].to_i
    
    @question = Question.new(params[:question])
    @question.admin_id = session[:admin_id]
    @question.tag_list = params[:as_values_tags]
    
    @type = params['question']['ques_type'] if params['question']['ques_type']
    
    if @question.save
      if params[:question][:option]
        if params[:question][:answer].class != String
          params[:question][:option].each do |opt_i, opt|
            if opt != ""
              Option.create(:body => opt, :question_id => @question.id)
              params[:question][:answer].each do |ans_i, ans|
                Answer.create(:body => opt, :question_id => @question.id) if opt_i.to_s == ans
              end
            end
          end
        else
          params[:question][:option].each do |opt_i, opt|
            if opt != ""
              Option.create(:body => opt, :question_id => @question.id)
              Answer.create(:body => opt, :question_id => @question.id) if opt_i.to_s == params[:question][:answer]
            end
          end
        end
      else
        Answer.create(:body => params[:question][:answer], :question_id => @question.id)
      end
      redirect_to(@question, :notice => 'Question was successfully created.')
    else
      render :action => "new"
    end
  end
    
  def update
    params[:question][:category_id] = params[:question][:category_id].to_i
    
    @question.admin_id = session[:admin_id]
    @question.tag_list = params[:as_values_tags]
    
    @type = params['question']['ques_type'] if params['question']['ques_type']
    
    answers = @question.answers
    options = @question.options
    
    if @question.update_attributes(params[:question])
      if params[:question][:option]
        c = 0
        params[:question][:option].each do |opt_i, opt|
          if opt != "" && !options[c].nil?
            options[c].update_attributes(:body => opt)
            c += 1
          elsif opt != "" && options[c].nil?
            Option.create(:body => opt, :question_id => @question.id)
          end
        end
        (c...options.length).each { |i| options[i].destroy } if (c < options.length)
              
        c = 0
        if params[:question][:answer].class != String
          params[:question][:option].each do |opt_i, opt|
            params[:question][:answer].each do |ans_i, ans|
              if opt != "" && opt_i.to_s == ans
                if !answers[c].nil?
                  answers[c].update_attributes(:body => opt)
                  c += 1
                else
                  Answer.create(:body => opt, :question_id => @question.id)
                end
                break;
              end
            end
          end
          (c...answers.length).each { |i| answers[i].destroy } if (c < answers.length)
        else
          params[:question][:option].each do |opt_i, opt|
            answers.first.update_attributes(:body => opt) if (opt != "" && opt_i.to_s == params[:question][:answer])
          end
          (1...answers.length).each { |i| answers[i].destroy } if (1 < answers.length)
        end
      else
        options.each { |opt| opt.destroy }
        answers.first.update_attributes(:body => params[:question][:answer])
        (1...answers.length).each { |i| answers[i].destroy } if (1 < answers.length)
      end
      
      redirect_to(@question, :notice => 'Question was successfully updated.') 
    else
      render :action => "edit" 
    end
  end


  def destroy
    @question.destroy
    redirect_to(questions_url) 
  end
  
  def change_answer_div

    @question = Question.find(params[:id]) if params[:id] != ""
    
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
  
  def admin_signed_in
    unless session["devise.googleapps_data"]
      session[:admin_id] = nil
      redirect_to new_admin_session_path
    end
  end
  
  def get_question_by_id
    @question = Question.find(params[:id])
  end
  
end
