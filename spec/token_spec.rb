# frozen_string_literal: true

require 'support/dummy_user'

RSpec.describe JWT::Auth::Token do
  before :each do
    JWT::Auth.configure do |config|
      config.token_lifetime = 24.hours

      config.secret = 'mysecret'
    end
  end

  let(:user) { DummyUser.new }

  describe 'properties' do
    let(:token) { token = JWT::Auth::Token.from_user user }

    it 'has an expiration' do
      expect(token).to respond_to :expiration
      expect(token.expiration).to be_nil
    end

    it 'has a subject' do
      expect(token).to respond_to :subject
      expect(token.subject).to eq user
    end
  end

  describe 'from token' do
    let(:jwt) do
      payload = {
        :exp => JWT::Auth.token_lifetime.from_now.to_i,
        :sub => user.id,
        :ver => user.token_version
      }
      JWT.encode payload, JWT::Auth.secret
    end

    let(:token) { JWT::Auth::Token.from_token jwt }

    it 'matches expiration' do
      expect(token.expiration).to eq JWT::Auth.token_lifetime.from_now.to_i
    end

    it 'matches subject' do
      expect(token.subject.id).to eq user.id
      expect(token.subject.token_version).to eq user.token_version
    end
  end
end
