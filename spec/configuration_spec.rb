# frozen_string_literal: true
require 'spec_helper'

RSpec.describe JWT::Auth do
  it 'configures correctly' do
    JWT::Auth.configure do |config|
      config.token_lifetime = 666
      config.secret = 'mysecret'
    end

    expect(subject.token_lifetime).to eq 666
    expect(subject.secret).to eq 'mysecret'
  end
end
