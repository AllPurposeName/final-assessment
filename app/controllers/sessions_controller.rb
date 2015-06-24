class SessionsController < ApplicationController

  def create
    user = User.find_or_create_with_oauth(request.env["omniauth.auth"])
    if user
      session[:user_id] = user.id
      redirect_to root_path
      flash[:notice] = "Welcome #{user.name}!"
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end
end
