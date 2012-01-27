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
  
  ## redirect_to appropriate page with notice if not found
  def show
    flash[:notice] = 'Admin not found' and redirect_to :root unless @admin = Admin.where(:id => params[:id]).first
  end
end
