class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include JWT::Auth::Authentication

  rescue_from JWT::Auth::UnauthorizedError, :with => :handle_unauthorized

  protected

  def handle_unauthorized
    head :unauthorized
  end
end
