class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    before_action :set_default_response_format
    skip_before_filter :verify_authenticity_token

    before_filter :set_cache_headers

    private
    def set_cache_headers
        response.headers["Cache-Control"] = "no-cache, no-store"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end

    protected
    def authenticate
        authenticate_token || render_unauthorized
    end

    def authenticate_token
        authenticate_with_http_token do |token, options|
            @current_user = User.find_by(token: token.strip)
            @current_user
        end
    end

    def render_unprocessable_entity(error)
        render_error error, :unprocessable_entity
    end

    def render_bad_request(error)
        render_error error, :bad_request
    end

    def render_unauthorized
        render_error 'Bad credentials', :unauthorized
    end

    def render_forbidden(error)
        render_error error, :forbidden
    end

    def render_success
        render :json => {}, :status => 200
    end

    def render_not_found(error)
        render_error error, :not_found
    end

    def set_default_response_format
        request.format = :json
    end

    def render_error(error, status)
        render :json => {:error => error}, :status => status
    end

    def render_errors(errors)
        render :json => {:has_errors => true, :errors => errors}, :status => :unprocessable_entity
    end

end
