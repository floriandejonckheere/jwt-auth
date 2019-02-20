# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JWT::Auth::RefreshToken do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:user) { User.create! :activated => true }

  ##
  # Subject
  #
  subject(:token) { described_class.new }

  ##
  # Tests
  #
  describe '#type' do
    it 'returns the correct token type' do
      expect(subject.type).to eq :refresh
    end
  end

  describe '#lifetime' do
    it { is_expected.to respond_to :lifetime }

    it 'returns an integer' do
      expect(subject.lifetime).to be_a_kind_of Integer
    end
  end
end
