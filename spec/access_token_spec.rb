# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JWT::Auth::AccessToken do
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
  describe '#valid?' do
    subject(:token) { described_class.new :subject => user, :issued_at => Time.now.to_i, :token_version => user.token_version, :type => type }
    let(:type) { :access }

    it { is_expected.to be_valid }

    context 'when the type is nil' do
      let(:type) { nil }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#lifetime' do
    it { is_expected.to respond_to :lifetime }

    it 'returns an integer' do
      expect(subject.lifetime).to be_a_kind_of Integer
    end
  end
end
