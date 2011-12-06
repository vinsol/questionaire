class QuestionsController < ApplicationController
  before_filter :admin_signed_in
  
  # GET /questions
  # GET /questions.xml
  def index
    @questions = Question.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.xml
  def show
    @question = Question.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.xml
  def new
    @question = Question.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
    #params[:question] = { :answer => "priyank"}
  end

  # POST /questions
  # POST /questions.xml
  def create
    params[:question][:category_id] = params[:question][:category_id].to_i
    @question = Question.new(params[:question])
    @question.admin_id = session[:admin_id]
    @question.tag_list = params[:as_values_tags]
    if params['question']['ques_type']
      @type = params['question']['ques_type']
    end
      
    respond_to do |format|
      if @question.save
        if params[:question][:option]
          if params[:question][:answer].class != String
            params[:question][:option].each do |opt_i, opt|
              if opt != ""
                option = Option.create(:body => opt, :question_id => @question.id)
                params[:question][:answer].each do |ans_i, ans|
                  if opt_i.to_s == ans
                    answer = Answer.create(:body => opt, :question_id => @question.id)
                  end
                end
              end
            end
          else
            params[:question][:option].each do |opt_i, opt|
              if opt != ""
                option = Option.create(:body => opt, :question_id => @question.id)
                if opt_i.to_s == params[:question][:answer]
                  answer = Answer.create(:body => opt, :question_id => @question.id)
                end
              end
            end
          end
        else
          answer = Answer.create(:body => params[:question][:answer], :question_id => @question.id)
        end
        format.html { redirect_to(@question, :notice => 'Question was successfully created.') }
        format.xml  { render :xml => @question, :status => :created, :location => @question.id }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end
    

  # PUT /questions/1
  # PUT /questions/1.xml
  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to(@question, :notice => 'Question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.xml
  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to(questions_url) }
      format.xml  { head :ok }
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
end
