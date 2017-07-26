JWT::Auth.configure do |config|
  ##
  # Token lifetime
  #
  config.token_lifetime = 24.hours

  ##
  # JWT secret
  #
  config.secret = 'mysecret'
end
