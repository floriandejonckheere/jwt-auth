# JWT::Auth [![Travis](https://travis-ci.org/floriandejonckheere/jwt-auth.svg?branch=master)](https://travis-ci.org/floriandejonckheere/jwt-auth) [![Coverage Status](https://coveralls.io/repos/github/floriandejonckheere/jwt-auth/badge.svg)](https://coveralls.io/github/floriandejonckheere/jwt-auth)

JWT-based authentication middleware for Rails API without Devise

## Installation

Add this line to your application's Gemfile:

    gem 'jwt-auth'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jwt-auth

## Usage

Create an initializer:

```ruby
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
  config.secret = Rails.application.secrets.secret_key_base
end
```

Do not try to set the `model` configuration property in the initializer, as this property is already set by including the `Authenticatable` concern in your model.

Include model methods in your user model. This adds a dummy `#find_by_token` method, which you can override, and a validation for `#token_version`.

```ruby
class User < ApplicationRecord
  include JWT::Auth::Authenticatable
end
```

Optionally, override the `#find_by_token` method on your model to allow additional checks (for example account activation):

```ruby
def self.find_by_token(params)
  find_by params.merge :activated => true
end
```

Generate the `token_version` migration:

```ruby
class AddTokenVersionToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :token_version, :integer, :null => false, :default => 1
  end
end

```

Include controller methods in your `ApplicationController` and handle unauthorized errors:

```ruby
class ApplicationController < ActionController::API
  include JWT::Auth::Authentication
  
  rescue_from JWT::Auth::UnauthorizedError, :with => :handle_unauthorized
  
  protected
  
  def handle_unauthorized
    head :unauthorized
  end
end
```

Set callbacks on routes:

```ruby
class MyController < ApplicationController
  # Authenticates user from request header
  # The callback raises an UnauthorizedError on missing or invalid token 
  before_action :authenticate_user, :except => %i[create]
  
  # Validate token if there is a token present
  # The callback raises an UnauthorizedError only if there is a token present, and it is invalid
  # This prevents users from using an expired token on an unauthenticated route and getting a HTTP 2xx
  before_action :validate_token 
  
  # Renew token and set response header
  after_action :renew_token
end
```

## Migration guide

### From 4.2 to 5.0

5.0 includes breaking changes and introduces the concept of a refresh and an access token.
Please remove jwt-auth entirely from your application, and reinstall it using the instructions above.

## Contributing

1. Fork it ( https://github.com/floriandejonckheere/jwt-auth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
