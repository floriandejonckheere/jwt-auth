# JWT::Auth

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
  # Token lifetime (in hours)
  #
  config.token_lifetime = 24
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

Include controller methods in your `ApplicationController`:

```ruby
class ApplicationController < ActionController::API
  include JWT::Auth::Authentication
end
```

Set `before_action` on routes:

```ruby
class MyController < ApplicationController
  before_action :authenticate_user
end
```

## Contributing

1. Fork it ( https://github.com/floriandejonckheere/jwt-auth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
