# frozen_string_literal: true

require 'securerandom'

require 'rails_helper'

RSpec.describe JWT::Auth do
  it 'configures correctly' do
    JWT::Auth.configure do |config|
      config.token_lifetime = 24.hours
      config.secret = 'mysecret'
    end

    expect(subject.token_lifetime).to eq 24.hours
    expect(subject.secret).to eq 'mysecret'
    expect(subject.model).to eq User
  end
end
