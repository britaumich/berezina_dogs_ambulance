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
      # Find user by a signed, expiring token instead of using the numeric primary key
      begin
        user_session = Session.joins(:user).find_signed(
          token,
          purpose: 'api_session'
        )
      rescue ActiveSupport::MessageVerifier::InvalidSignature, ArgumentError => e
        user_session = nil
      end
      if user_session 
        @current_user = user_session.user
        @current_session = user_session
        true
      else
        false
      end
    end
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
    # Only default to JSON when the client hasn't explicitly requested another format.
    # Respect an explicit format in the URL/params (e.g. /api/animals.csv).
    return if params[:format].present?
    # Respect a specific non-JSON Accept header when provided.
    accept = request.headers['Accept']
    if accept.present? && !accept.include?('*/*') && !accept.include?('application/json')
      return
    end
    # Fall back to JSON as the default format for API responses.
    request.format = :json
  end

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def handle_api_error(exception)
    # Log full error details server-side
    Rails.logger.error("[API ERROR] #{exception.class}: #{exception.message}")
    Rails.logger.error(exception.backtrace.join("\n")) if exception.backtrace
    # Return a generic error message to clients
    error_response = { error: 'Internal server error' }
    error_response[:request_id] = request.request_id if request.respond_to?(:request_id)
    # In non-production environments, include more detail to aid debugging
    if defined?(Rails) && (Rails.env.development? || Rails.env.test?)
      error_response[:details] = exception.message
    end
    render json: error_response, status: :internal_server_error
  end

  def handle_not_found(exception)
    render json: { error: 'Not found' }, status: :not_found
  end

  def handle_unauthorized(exception)
    render json: { error: 'Access denied' }, status: :forbidden
  end
end
