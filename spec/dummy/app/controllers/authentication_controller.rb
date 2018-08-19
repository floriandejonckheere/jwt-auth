class AuthenticationController < ApplicationController
  # Refresh request token
  before_action :refresh_request_token, :only => :refresh

  # Authenticates user from request header
  before_action :authenticate_request_token, :only => :private

  def refresh

  end

  def private
    head :no_content
  end

  def public
    head :no_content
  end
end
