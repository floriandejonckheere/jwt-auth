# JWT::Auth [![Travis](https://travis-ci.org/floriandejonckheere/jwt-auth.svg?branch=master)](https://travis-ci.org/floriandejonckheere/jwt-auth) [![Coverage Status](https://coveralls.io/repos/github/floriandejonckheere/jwt-auth/badge.svg)](https://coveralls.io/github/floriandejonckheere/jwt-auth)

JWT-based authentication middleware for Rails API without Devise

## Concept

JWT::Auth uses a two-token authentication mechanism.
When the client authenticates against the application, a long-lived token is generated (called a refresh token).
Using this long-lived token, a short-lived token can be requested using a different endpoint.
This short-lived token (called an access token) can then be used to manipulate the API.

```
     +--------+                               +---------------+
     |        |---- Authentication Request -->|    Sign in    |
     |        |                               |    Endpoint   |
     |        |<--------- Refresh Token ------|               |
     |        |                               +---------------+
     |        |                             
     |        |                               +---------------+
     |        |--------- Refresh Token ------>|    Refresh    |
     | Client |                               |    Endpoint   |
     |        |<--------- Access Token -------|               |
     |        |                               +---------------+
     |        |
     |        |                               +---------------+
     |        |---------- Access Token ------>|      API      |
     |        |                               |    Endpoint   |
     |        |<------- Protected Resource ---|               |
     +--------+                               +---------------+
```

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
  
  # Validate validity of token (if present) on all routes
  before_action :validate_token

  protected
  
  def handle_unauthorized
    head :unauthorized
  end
end
```

Add the appropriate filters on your authentication API actions:

```ruby
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
  def update
    # Return a short-lived access token
    set_access_token

    head :no_content
  end
end

```

Set the appropriate filters on your API actions:

```ruby
class ContentController < ApplicationController
  # Validate access token on all actions
  before_action :validate_access_token

  # Require token for protected actions
  before_action :require_token, :only => :authenticated

  ##
  # GET /unauthenticated
  #
  # This endpoint is not protected, performing a request without a token, or with a valid token will succeed
  # Performing a request with an invalid token will raise an UnauthorizedError
  #
  def unauthenticated
    head :no_content
  end

  ##
  # GET /unauthenticated
  #
  # This endpoint is protected, performing a request with a valid access token will succeed
  # Performing a request without a token, with an invalid token or with a refresh token will raise an UnauthorizedError
  #
  def authenticated
    head :no_content
  end
end
```

You can find a fully working sample application in [spec/dummy](spec/dummy).

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

For your convenience, scripts to automatically increment version number and build a release were included in `bin/`.
