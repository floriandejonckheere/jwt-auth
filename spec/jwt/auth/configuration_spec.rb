# frozen_string_literal: true

require 'securerandom'

require 'rails_helper'

RSpec.describe JWT::Auth do
  ##
  # Configuration
  #
  JWT::Auth.configure do |config|
    config.refresh_token_lifetime = 1.year
    config.access_token_lifetime = 2.hours
    config.secret = 'mysecret'
  end

  ##
  # Test variables
  #

  # Ensure the User model is autoloaded, which initializes the JWT::Auth.model configuration entry
  before { User }

  ##
  # Subject
  #
  subject { JWT::Auth }

  ##
  # Tests
  #
  it { is_expected.to have_attributes :refresh_token_lifetime => 1.year, :access_token_lifetime => 2.hours, :secret => 'mysecret', :model => 'User' }
end
