class SessionsController < ApplicationController
  def create
    session["oauth_uid"] = env["omniauth.auth"].uid
    session["oauth_token"] = env["omniauth.auth"].credentials.token
    redirect_to root_path
  end

  def destroy
    session.delete("oauth_uid")
    session.delete("oauth_token")
    redirect_to root_path
  end
end
