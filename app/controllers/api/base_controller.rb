class Api::BaseController < ActionController::Base
  # Use a null session for API endpoints to avoid CSRF issues while keeping state stateless
  protect_from_forgery with: :null_session
  
  # Include Pundit for authorization
  include Pundit::Authorization
  
  # Don't include ApplicationHelper and other web-specific modules
  before_action :require_api_authentication
  before_action :set_json_format

  rescue_from StandardError, with: :handle_api_error
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from Pundit::NotAuthorizedError, with: :handle_unauthorized

  protected

  def require_api_authentication
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      # Find user by token - we'll store tokens in a simple way for now
      user_session = Session.joins(:user).find_by(id: token)
      if user_session && token_valid?(user_session)
        @current_user = user_session.user
        @current_session = user_session
        true
      else
        false
      end
    end
  end

  def token_valid?(session)
    # Token is valid if session was created within last 30 days
    session.created_at > 30.days.ago
  end

  def current_user
    @current_user
  end

  def current_session
    @current_session
  end

  def pundit_user
    { user: current_user, role: current_role }
  end

  def current_role
    return nil unless current_user
    admin_user = AdminUser.find_by(email: current_user.email_address)
    admin_user&.role
  end

  def set_json_format
    request.format = :json
  end

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def handle_api_error(exception)
    render json: { error: exception.message }, status: :internal_server_error
  end

  def handle_not_found(exception)
    render json: { error: 'Not found' }, status: :not_found
  end

  def handle_unauthorized(exception)
    render json: { error: 'Access denied' }, status: :forbidden
  end
end
