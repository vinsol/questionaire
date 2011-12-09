class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def after_sign_out_path_for(resource_or_scope)
    session[:admin_id] = nil
    new_admin_session_path
  end
  
  private
  
  def admin_signed_in
    unless session["devise.googleapps_data"]
      session[:admin_id] = nil
      redirect_to new_admin_session_path
    end
  end
end
