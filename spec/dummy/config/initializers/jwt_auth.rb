# frozen_string_literal: true

JWT::Auth.configure do |config|
  ##
  # Refresh token lifetime
  #
  config.refresh_token_lifetime = 1.year

  ##
  # Access token lifetime
  #
  config.access_token_lifetime = 2.hours

  ##
  # JWT secret
  #
  config.secret = 'mysecret'
end
