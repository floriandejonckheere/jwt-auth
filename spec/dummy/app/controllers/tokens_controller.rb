# frozen_string_literal: true

class TokensController < ApplicationController
  # Validate refresh token on refresh action
  before_action :validate_refresh_token, :only => :update

  # Require token only on refresh action
  before_action :require_token, :only => :update

  ##
  # POST /token
  #
  # Sign in the user
  #
  # ::request::
  #
  # @body email, password
  #
  # ::response::
  #
  # @header Authorization A long lived refresh token
  #
  def create
    @user = User.active.find_by :email => params[:email], :password => params[:password]
    raise JWT::Auth::UnauthorizedError unless @user

    # Return a long-lived refresh token
    set_refresh_token @user

    head :no_content
  end

  ##
  #
  # PATCH /token
  #
  # Refresh access token
  #
  # ::request::
  #
  # @header Authorization Refresh token
  #
  # ::response::
  #
  # @header Authorization Access token
  #
  def update
    # Return a short-lived access token
    set_access_token

    head :no_content
  end
end
