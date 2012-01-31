class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_admin, :admin_signed_in
  
  def after_sign_out_path_for(resource_or_scope)
    session[:admin_id] = nil
    new_admin_session_path
  end
  
  protected
  
  def current_admin
    @admin ||= Admin.where(:id => session[:admin_id]).first
  end  
    
  def admin_signed_in
    unless session["devise.googleapps_data"]
      session[:admin_id] = nil
      redirect_to new_admin_session_path
    end
  end
end
