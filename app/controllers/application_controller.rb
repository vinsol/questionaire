class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method  :admin_signed_in#, :current_admin
  
  def after_sign_out_path_for(resource_or_scope)
    session[:admin_id] = nil
    new_admin_session_path
  end
  
  protected
  
  def admin_signed_in
    unless session["devise.googleapps_data"]
      session[:admin_id] = nil
      redirect_to new_admin_session_path
    end
  end
  
#  def current_admin
#    @current_admin ||= Admin.where(:id => session[:admin_id]).first
#  end
end
