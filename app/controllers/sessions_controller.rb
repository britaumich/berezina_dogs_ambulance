class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  allow_unauthenticated_access only: %i[ destroy ] # edgecase to deal with email confirmations
  skip_forgery_protection only: :create, if: :api_request?
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: 'Try again later.' }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      # Check if user's email exists in AdminUser table
      unless AdminUser.exists?(email: user.email_address)
        if api_request?
          render json: { error: t('forms.messages.access_denied') }, status: :forbidden
        else
          redirect_to new_session_path, alert: t('forms.messages.access_denied')
        end
        return
      end
      
      start_new_session_for user
      if api_request?
        render json: { message: 'Login successful', user_email: user.email_address }
      else
        redirect_to after_authentication_url
      end
    else
      if api_request?
        render json: { error: t('forms.messages.Try another email address or password') }, status: :unauthorized
      else
        redirect_to new_session_path, alert: t('forms.messages.Try another email address or password')
      end
    end
  end

  def destroy
    terminate_session
    if api_request?
      render json: { message: 'Logout successful' }
    else
      redirect_to new_session_path
    end
  end

  private

  def api_request?
    request.format.json? || 
    request.headers['Content-Type']&.include?('application/json') ||
    request.headers['Accept']&.include?('application/json') ||
    request.user_agent&.include?('curl') ||
    !request.headers['X-Requested-With'].nil?
  end
end
