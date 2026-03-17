class Api::SessionsController < Api::BaseController
  # Allow unauthenticated access for login/signup endpoints
  skip_before_action :require_api_authentication, only: [:create]
  
  # POST /api/sessions
  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      # Check if user's email exists in AdminUser table
      unless AdminUser.exists?(email: user.email_address)
        render json: { error: 'Access denied' }, status: :forbidden
        return
      end

      # Create a new session (this will be our token)
      session = create_api_session_for(user)
      
      render json: { 
        token: session.id,
        user_email: user.email_address,
        expires_at: 30.days.from_now.iso8601
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # DELETE /api/sessions
  def destroy
    current_session&.destroy
    render json: { message: 'Logged out successfully' }, status: :ok
  end

  private

  def create_api_session_for(user)
    user.sessions.create!(
      user_agent: request.user_agent || 'API Client', 
      ip_address: request.remote_ip
    )
  end
end