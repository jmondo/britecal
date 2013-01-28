class SessionsController < ApplicationController
  def create
    auth_hash = env["omniauth.auth"]
    user = User.find_or_create_by_auth_hash!(auth_hash)
    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end
end
