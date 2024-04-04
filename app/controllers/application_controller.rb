class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  # rescue_from StandardError, with: :render_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404
    render template: "errors/404", status: :not_found, layout: 'application'
  end

  def render_500
    render template: "errors/500", status: :internal_server_error, layout: 'application'
  end

  def after_sign_in_path_for(_resource)
    mypage_path
  end

  def after_sign_out_path_for(_resource)
    root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :image, :image_cache])
  end
end
