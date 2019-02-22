# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TokensController do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:user) { User.create :activated => true, :email => 'foo@bar', :password => 'foobar' }

  let(:headers) do
    { 'Authorization' => "Bearer #{token.to_jwt}" }
  end

  # Ensure the user is created, which autoloads the model and initializes the JWT::Auth.model configuration entry
  before { user }

  ##
  # Tests
  #
  describe 'POST /' do
    let(:user) { User.create :activated => activated, :email => 'foo@bar', :password => 'foobar' }
    let(:activated) { true }
    let(:password) { 'foobar' }

    subject { post :create, { :params => { :email => 'foo@bar', :password => password } } }

    it { is_expected.to have_http_status :no_content }
    it { is_expected.to return_token JWT::Auth::RefreshToken }

    context 'when the credentials are incorrect' do
      let(:password) { 'barfoo' }

      it { is_expected.to have_http_status :unauthorized }
      it { is_expected.not_to return_token }
    end

    context 'when the user is not activated' do
      let(:activated) { false }

      it { is_expected.to have_http_status :unauthorized }
      it { is_expected.not_to return_token }

      context 'when the credentials are incorrect' do
        let(:password) { 'barfoo' }

        it { is_expected.to have_http_status :unauthorized }
        it { is_expected.not_to return_token }
      end
    end
  end

  describe 'PATCH /' do
    let(:user) { User.create :activated => activated, :email => 'foo@bar', :password => 'foobar' }
    let(:activated) { true }

    subject { patch :update }

    context 'when no token is present' do
      it { is_expected.to have_http_status :unauthorized }
      it { is_expected.not_to return_token }
    end

    context 'when a refresh token is present' do
      let(:token) { JWT::Auth::RefreshToken.new :subject => user }

      before { @request.headers.merge! headers }

      it { is_expected.to have_http_status :no_content }
      it { is_expected.to return_token JWT::Auth::AccessToken }

      context 'when the token is invalid' do
        before { user.increment! :token_version }

        it { is_expected.to have_http_status :unauthorized }
        it { is_expected.not_to return_token }
      end
    end

    context 'when an access token is present' do
      let(:token) { JWT::Auth::AccessToken.new :subject => user }

      before { @request.headers.merge! headers }

      it { is_expected.to have_http_status :unauthorized }
      it { is_expected.not_to return_token }

      context 'when the token is invalid' do
        before { user.increment! :token_version }

        it { is_expected.to have_http_status :unauthorized }
        it { is_expected.not_to return_token }
      end
    end

    context 'when the user is not activated' do
      let(:activated) { false }

      context 'when no token is present' do
        it { is_expected.to have_http_status :unauthorized }
        it { is_expected.not_to return_token }
      end

      context 'when a refresh token is present' do
        let(:token) { JWT::Auth::RefreshToken.new :subject => user }

        before { @request.headers.merge! headers }

        it { is_expected.to have_http_status :unauthorized }
        it { is_expected.not_to return_token }

        context 'when the token is invalid' do
          before { user.increment! :token_version }

          it { is_expected.to have_http_status :unauthorized }
          it { is_expected.not_to return_token }
        end
      end

      context 'when an access token is present' do
        let(:token) { JWT::Auth::AccessToken.new :subject => user }

        before { @request.headers.merge! headers }

        it { is_expected.to have_http_status :unauthorized }
        it { is_expected.not_to return_token }

        context 'when the token is invalid' do
          before { user.increment! :token_version }

          it { is_expected.to have_http_status :unauthorized }
          it { is_expected.not_to return_token }
        end
      end
    end
  end
end
