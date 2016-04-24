class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_default_response_format

  protected
  def authenticate
  	authenticate_token || render_unauthorized
  end

  def authenticate_token
  	authenticate_with_http_token do |token, options|
  		@current_user = User.find_by(token: token)
  		@current_user
  	end
  end

  def render_unauthorized
  	self.headers['WWW-Authenticate'] = 'Token realm="Petsee"'
  	render json: 'Bad credentials', status: 401
  end

  def set_default_response_format
    request.format = :json
  end

end
