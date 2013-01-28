class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user?, :current_user

  private

  def current_user
    @user ||= session[:user_id] && User.find_by_id(session[:user_id])
  end

  def current_user?
    !!current_user
  end
end
