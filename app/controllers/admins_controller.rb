class AdminsController < ApplicationController

  def new
    @admin = Admin.new
  end
  
  def create
    @admin = Admin.new(:email => params[:admin][:email])
    if @admin.save
      Notifier.deliver_contact(params[:admin][:email], "added at vinsol's questionaire", "your email id is been added at vinsol's questionaire as admin")
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
