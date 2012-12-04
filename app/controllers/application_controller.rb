class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_uid?

  def current_uid
    session["oauth_uid"]
  end

  def current_token
    session["oauth_token"]
  end

  def current_uid
    session["oauth_token"]
  end

  private

  def current_uid?
    current_uid.present?
  end
end
