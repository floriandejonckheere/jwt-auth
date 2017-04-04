# frozen_string_literal: true

require 'jwt/auth'

class DummyUser
  include JWT::Auth::Authenticatable

  attr_accessor :id, :token_version

  def initialize(params = {})
    self.id = params[:id] || Random.rand(1000)
    self.token_version = params[:token_version] || 1
  end

  def self.find_by(params)
    DummyUser.new params
  end
end
