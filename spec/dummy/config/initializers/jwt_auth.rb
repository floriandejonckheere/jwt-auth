JWT::Auth.configure do |config|
  ##
  # Refresh token lifetime
  #
  config.refresh_token_lifetime = 2.weeks

  ##
  # Request token lifetime
  #
  config.request_token_lifetime = 1.hour

  ##
  # JWT secret
  #
  config.secret = 'mysecret'
end
