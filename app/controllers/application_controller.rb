class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  before_action :require_authentication
  before_action :set_locale
  before_action :set_render_cart
  before_action :initialize_cart

  helper_method :current_user

  def current_user
    Current.session&.user
  end

  def set_locale
    if cookies[:educator_locale] && I18n.available_locales.include?(cookies[:educator_locale].to_sym)
      l = cookies[:educator_locale].to_sym
    else
      l = I18n.default_locale
      cookies.permanent[:educator_locale] = l
    end
    I18n.locale = l
  end

  def redirect_back_or_default(notice = '', alert = false, default = root_url)
    if alert
      flash[:alert] = notice
    else
      flash[:notice] = notice
    end
    url = session[:return_to]
    session[:return_to] = nil
    redirect_to(url, anchor: 'top' || default)
  end

  def set_render_cart
    @render_cart = true
  end

  def initialize_cart
    @cart ||= Cart.find_by(id: session[:cart_id])

    if @cart.nil?
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

end
