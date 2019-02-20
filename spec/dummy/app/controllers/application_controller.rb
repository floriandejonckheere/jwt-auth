class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include JWT::Auth::Authentication

  rescue_from JWT::Auth::UnauthorizedError, :with => :handle_unauthorized

  # Validate validity of token (if present) on all routes
  before_action :validate_token

  protected

  def handle_unauthorized
    head :unauthorized
  end
end
