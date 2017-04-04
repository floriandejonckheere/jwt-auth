# frozen_string_literal: true

require 'support/dummy_user'

RSpec.describe JWT::Auth do
  it 'configures correctly' do
    JWT::Auth.configure do |config|
      config.token_lifetime = 666
      config.secret = 'mysecret'
    end

    expect(subject.token_lifetime).to eq 666
    expect(subject.secret).to eq 'mysecret'
    expect(subject.model).to eq DummyUser
  end
end
