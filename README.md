# JWT::Auth [![Travis](https://travis-ci.org/floriandejonckheere/jwt-auth.svg?branch=master)](https://travis-ci.org/floriandejonckheere/jwt-auth) [![Coverage Status](https://coveralls.io/repos/github/floriandejonckheere/jwt-auth/badge.svg)](https://coveralls.io/github/floriandejonckheere/jwt-auth)

JWT-based authentication middleware for Rails API without Devise, API layer agnostic.

**Heads up**: starting with jwt-auth version 5, the authentication layer now uses a system of two tokens which is incompatible with jwt-auth 4 and below. 

## Overview

jwt-auth works with a two-token approach to authentication. When the user authenticates successfully for the first time, the server sends back a long-lived (typically weeks) **refresh token**. This token can then be used by the client to request a short-lived (typically minutes or hours) **request token** . Only the request token can be used to perform API operations. Once this token expires, the client has to request a new one using the refresh token.

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
  config.refresh_token_lifetime = 2.weeks
  
  ##
  # Request token lifetime
  #
  config.request_token_lifetime = 1.hour
  
  ##
  # JWT secret
  #
  config.secret = Rails.application.secrets.secret_key_base
end
```

Include model methods in your user model:

```ruby
class User < ApplicationRecord
  include JWT::Auth::Authenticatable
end
```

Optionally, define the `find_by_token` method on your model to allow additional checks (for example account activation):

```ruby
def self.find_by_token(params)
  find_by params.merge :activated => true
end
```

Add a `token_version` field to your user model:

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

Set up the refresh token route and protect API routes with a callback:

```ruby
class MyController < ApplicationController
  # Refresh request token
  before_action :refresh_request_token, :only => :refresh 

  # Authenticates user from request header
  before_action :authenticate_request_token, :only => :update

  def refresh
    # Empty refresh action
  end
  
  def update
    # Your API logic here
  end
end
```

## Contributing

1. Fork it ( https://github.com/floriandejonckheere/jwt-auth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
