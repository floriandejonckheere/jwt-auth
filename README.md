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
  # Token lifetime
  #
  config.token_lifetime = 24.hours
  
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

Set callbacks on routes:

```ruby
class MyController < ApplicationController
  # Authenticates user from request header
  before_action :authenticate_user
  
  # Renew token and set response header
  after_action :renew_token
end
```

## Contributing

1. Fork it ( https://github.com/floriandejonckheere/jwt-auth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
