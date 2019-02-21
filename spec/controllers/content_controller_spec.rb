# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentController do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:user) { User.create :activated => true }

  let(:headers) do
    { 'Authorization' => "Bearer #{token.to_jwt}" }
  end

  # Ensure the user is created, which autoloads the model and initializes the JWT::Auth.model configuration entry
  before { user }

  ##
  # Tests
  #
  describe 'GET /unauthenticated' do
    subject { get :unauthenticated }

    context 'when no token was specified' do
      it { is_expected.to have_http_status :no_content }
    end

    context 'when a refresh token was specified' do
      let(:token) { JWT::Auth::RefreshToken.new :subject => user }

      before { @request.headers.merge! headers }

      context 'when the token was invalid' do
        before { user.increment! :token_version }

        it { is_expected.to have_http_status :unauthorized }
      end

      # Request will succeed because even if the token type is wrong, the endpoint is not protected
      context 'when the token was valid' do
        it { is_expected.to have_http_status :no_content }
      end
    end

    context 'when an access token was specified' do
      let(:token) { JWT::Auth::AccessToken.new :subject => user }

      before { @request.headers.merge! headers }

      context 'when the token was invalid' do
        before { user.increment! :token_version }

        it { is_expected.to have_http_status :unauthorized }
      end

      context 'when the token was valid' do
        it { is_expected.to have_http_status :no_content }
      end
    end
  end

  describe 'GET /authenticated' do
    subject { get :authenticated }

    context 'when no token was specified' do
      it { is_expected.to have_http_status :unauthorized }
    end

    context 'when a refresh token was specified' do
      let(:token) { JWT::Auth::RefreshToken.new :subject => user }

      before { @request.headers.merge! headers }

      context 'when the token was invalid' do
        before { user.increment! :token_version }

        it { is_expected.to have_http_status :unauthorized }
      end

      # Request will succeed because even if the token type is wrong, the endpoint is not protected
      context 'when the token was valid' do
        it { is_expected.to have_http_status :unauthorized }
      end
    end

    context 'when an access token was specified' do
      let(:token) { JWT::Auth::AccessToken.new :subject => user }

      before { @request.headers.merge! headers }

      context 'when the token was invalid' do
        before { user.increment! :token_version }

        it { is_expected.to have_http_status :unauthorized }
      end

      context 'when the token was valid' do
        it { is_expected.to have_http_status :no_content }
      end
    end
  end
end
