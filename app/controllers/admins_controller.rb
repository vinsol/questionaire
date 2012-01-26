class AdminsController < ApplicationController

  before_filter :admin_signed_in  
  
  def index
    @admins = Admin.all
  end
  
  def new
    @admin = Admin.new
  end
  
  def create
    @admin = Admin.new(:email => params[:admin][:email])
    if @admin.save
      redirect_to admin_path(@admin)
    else
      render :action => 'new'
    end
  end
  
  def show
    @admin = Admin.where(:id => params[:id]).first
  end
end
