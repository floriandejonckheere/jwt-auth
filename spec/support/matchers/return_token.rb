# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :return_token do |type|
  match do
    @actual = nil

    return false unless response.headers['Authorization']
    jwt = response.headers['Authorization'].scan(/Bearer (.*)$/).flatten.last

    return false unless jwt
    token = JWT::Auth::Token.from_jwt jwt

    return false unless jwt
    @actual = token.class

    token.is_a? type
  end

  diffable

  description { 'return a token in the response headers' }
end
