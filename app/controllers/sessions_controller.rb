class SessionsController < ApplicationController

  def create
    user = User.find_or_create_with_oauth(request.env["omniauth.auth"])
    session[:user_id] = user.id
    if user.description
      redirect_to root_path
      flash[:notice] = "Welcome #{user.name}!"
    else
      redirect_to information_path
      flash[:notice] = "Fill out some basic information before continuing."
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end
end
