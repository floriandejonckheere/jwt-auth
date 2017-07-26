class AuthenticationController < ApplicationController
  # Authenticates user from request header
  before_action :authenticate_user, :only => :private

  # Renew token and set response header
  after_action :renew_token

  def private
    head :no_content
  end

  def public
    head :no_content
  end
end
