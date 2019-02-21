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
    context 'when the user is not activated' do
      let(:user) { User.create :activated => false, :email => 'foo@bar', :password => 'foobar' }

      context 'when the credentials are incorrect' do
        subject { post :create, { :params => { :email => 'foo@bar', :password => 'barfoo' } } }

        it { is_expected.to have_http_status :unauthorized }
        it { is_expected.not_to return_token }
      end

      context 'when the credentials are correct' do
        subject { post :create, :params => { :email => 'foo@bar', :password => 'barfoo' } }

        it { is_expected.to have_http_status :unauthorized }
        it { is_expected.not_to return_token }
      end
    end

    context 'when the user is activated' do
      context 'when the credentials are incorrect' do
        subject { post :create, :params => { :email => 'foo@bar', :password => 'barfoo' } }

        it { is_expected.to have_http_status :unauthorized }
        it { is_expected.not_to return_token }
      end

      context 'when the credentials are correct' do
        subject { post :create, :params => { :email => 'foo@bar', :password => 'foobar' } }

        it { is_expected.to have_http_status :no_content }

        it { is_expected.to return_token JWT::Auth::RefreshToken }
      end
    end
  end

  describe 'PATCH /' do
    subject { patch :update }

    context 'when the user is not activated' do
      let(:user) { User.create :activated => false, :email => 'foo@bar', :password => 'foobar' }

      context 'when no token is present' do
        let(:headers) { nil }

        it { is_expected.to have_http_status :unauthorized }
      end

      context 'when a refresh token is present' do
        let(:token) { JWT::Auth::RefreshToken.new :subject => user }

        before { @request.headers.merge! headers }

        context 'when the token is valid' do
          it { is_expected.to have_http_status :unauthorized }
        end

        context 'when the token is invalid' do
          before { user.increment! :token_version }

          it { is_expected.to have_http_status :unauthorized }
        end
      end

      context 'when an access token is present' do
        let(:token) { JWT::Auth::AccessToken.new :subject => user }

        before { @request.headers.merge! headers }

        context 'when the token is valid' do
          it { is_expected.to have_http_status :unauthorized }
        end

        context 'when the token is invalid' do
          before { user.increment! :token_version }

          it { is_expected.to have_http_status :unauthorized }
        end
      end
    end

    context 'when the user is activated' do
      context 'when no token is present' do
        let(:headers) { nil }

        it { is_expected.to have_http_status :unauthorized }
      end

      context 'when a refresh token is present' do
        let(:token) { JWT::Auth::RefreshToken.new :subject => user }

        before { @request.headers.merge! headers }

        context 'when the token is valid' do
          it { is_expected.to have_http_status :no_content }
          it { is_expected.to return_token JWT::Auth::AccessToken }
        end

        context 'when the token is invalid' do
          before { user.increment! :token_version }

          it { is_expected.to have_http_status :unauthorized }
        end
      end

      context 'when an access token is present' do
        let(:token) { JWT::Auth::AccessToken.new :subject => user }

        before { @request.headers.merge! headers }

        context 'when the token is valid' do
          it { is_expected.to have_http_status :unauthorized }
        end

        context 'when the token is invalid' do
          before { user.increment! :token_version }

          it { is_expected.to have_http_status :unauthorized }
        end
      end
    end
  end
end
