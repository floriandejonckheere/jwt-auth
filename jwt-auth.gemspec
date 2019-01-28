# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jwt/auth/version'

Gem::Specification.new do |gem|
  gem.name          = 'jwt-auth'
  gem.version       = JWT::Auth::VERSION
  gem.authors       = ['Florian Dejonckheere']
  gem.email         = ['florian@floriandejonckheere.be']
  gem.summary       = 'JWT-based authentication for Rails API'
  gem.description   = 'Authentication middleware for Rails API that uses JWTs'
  gem.homepage      = 'https://github.com/floriandejonckheere/jwt-auth'
  gem.license       = 'MIT'

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'jwt', '~> 2.0'
  gem.add_runtime_dependency 'rails', '~> 5.2'

  gem.add_development_dependency 'bundler', '~> 1.17'
  gem.add_development_dependency 'rubocop', '~> 0.63'
  gem.add_development_dependency 'rake', '~> 12.3'
  gem.add_development_dependency 'rspec', '~> 3.8'
  gem.add_development_dependency 'rspec-rails', '~> 3.8'
  gem.add_development_dependency 'rdoc', '~> 6.1'
  gem.add_development_dependency 'coveralls', '~> 0.8'
  gem.add_development_dependency 'byebug'
  gem.add_development_dependency 'sqlite3'
end
