class Admins::OmniauthCallbacksController < ApplicationController

  def google_apps
    # You need to implement the method below in your model
    #p request.env["omniauth.auth"]['uid']
    
    @admin = Admin.find_for_googleapps_oauth(request.env["omniauth.auth"], current_admin)

    unless @admin
      redirect_to(new_admin_session_path, :notice => 'Unauthorized Access')
    else
      session["devise.googleapps_data"] = request.env["omniauth.auth"]
      session[:admin_id] = @admin.id
      redirect_to questions_path
    end
  end
end
