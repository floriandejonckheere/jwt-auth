# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jwt/auth/version'

Gem::Specification.new do |spec|
  spec.name          = 'jwt-auth'
  spec.version       = JWT::Auth::VERSION
  spec.authors       = ['Florian Dejonckheere']
  spec.email         = ['florian@floriandejonckheere.be']
  spec.summary       = 'JWT-based authentication for Rails API without Devise'
  spec.description   = 'Authentication middleware for Rails API that uses JWTs, without depending on Devise'
  spec.homepage      = 'https://github.com/floriandejonckheere/jwt-auth'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'jwt', '~> 1.5'
  spec.add_dependency 'rails', '~> 5.0'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rubocop', '~> 0.48'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
end
