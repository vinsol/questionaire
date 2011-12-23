class AdminsController < ApplicationController
  
  #before_filter :admin_signed_in
  
  def new
    @admin = Admin.new
  end
  
  def create
    @admin = Admin.new(:email => params[:admin][:email])
    if @admin.save
      Notifier.deliver_contact(params[:admin][:email], "added at vinsol's questionaire", "your email id has been added at vinsol's questionnaire as admin")
      return if request.xhr?
      redirect_to admin_path(@admin)
    else
      render :action => 'new'
    end
  end
  
  def show
    @admin = Admin.find(params[:id])
  end
end
