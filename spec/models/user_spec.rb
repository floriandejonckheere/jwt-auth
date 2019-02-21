# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  ##
  # Subject
  #
  ##
  # Tests
  #
  it { is_expected.to validate_presence_of :token_version }
  it { is_expected.to respond_to :find_by_token }

  it 'sets the JWT::Auth configuration model entry to User' do
    expect(JWT::Auth.model).to eq described_class.to_s
  end
end
