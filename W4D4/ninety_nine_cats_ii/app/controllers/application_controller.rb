class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :logged_in?

  helper_method :current_user, :logged_in?

  def login!(user)
    session[:session_token] = user.session_token
  end

  def current_user
    return false unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logout!
    current_user.reset_session_token
    session[:session_token] = nil
  end


  def logged_in?
    !!current_user
  end
end
