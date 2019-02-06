class AuthenticationController < ApplicationController
  # Authenticates user from request header
  before_action :authenticate_user, :only => :private

  # Validate token
  before_action :validate_token, :only => :validate

  # Renew token and set response header
  after_action :renew_token

  def public
    head :no_content
  end

  def private
    head :no_content
  end

  def validate
    head :no_content
  end
end
