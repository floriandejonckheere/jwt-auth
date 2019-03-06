# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jwt/auth/version'

Gem::Specification.new do |gem|
  gem.name          = 'jwt-auth'
  gem.version       = JWT::Auth::VERSION
  gem.authors       = ['Florian Dejonckheere']
  gem.email         = ['florian@floriandejonckheere.be']
  gem.date          = Time.now.utc.strftime '%Y-%m-%d'
  gem.summary       = 'JWT-based authentication for Rails API'
  gem.description   = 'Authentication middleware for Rails API that uses JWTs'
  gem.homepage      = 'https://github.com/floriandejonckheere/jwt-auth'
  gem.license       = 'MIT'

  gem.files         = `git ls-files -z`.split "\x0"
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename f }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w[lib]

  gem.add_runtime_dependency 'jwt'
  gem.add_runtime_dependency 'rails'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'byebug'
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'database_cleaner'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rdoc'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'semverse'
  gem.add_development_dependency 'shoulda-matchers'
  gem.add_development_dependency 'sqlite3', '~> 1.3.6'
end
