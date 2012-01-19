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
      # move in after_save/create
      redirect_to admin_path(@admin)
    else
      render :action => 'new'
    end
  end
  
  # use where
  def show
    @admin = Admin.find(params[:id])
  end
end
