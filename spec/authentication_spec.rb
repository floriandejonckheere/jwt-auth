# frozen_string_listeral: true

require 'rails_helper'

RSpec.describe AuthenticationController, :type => :request do
  let(:user) { User.create :activated => true }

  let(:headers) do
    {
      'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
    }
  end

  describe 'GET /public' do
    context 'activated user' do
      it 'is accessible without token' do
        get '/public'

        expect(response.status).to eq 204
      end

      it 'is accessible with token' do
        get '/public', :headers => headers

        expect(response.status).to eq 204
      end

      it 'renews the token' do
        get '/public', :headers => headers

        jwt = response.headers['Authorization'].scan(/Bearer (.*)$/).flatten.last
        token = JWT::Auth::Token.from_token jwt

        expect(token).to be_valid
      end
    end

    context 'disabled user' do
      let(:user) { User.new }

      it 'is accessible without token' do
        get '/public'

        expect(response.status).to eq 204
      end

      it 'is accessible with token' do
        get '/public', :headers => headers

        expect(response.status).to eq 204
      end
    end
  end

  describe 'GET /private' do
    context 'activated user' do
      it 'is not accessible without token' do
        get '/private'

        expect(response.status).to eq 401
      end

      it 'is accessible with token' do
        get '/private', :headers => headers

        expect(response.status).to eq 204
      end

      it 'renews the token' do
        get '/private', :headers => headers

        jwt = response.headers['Authorization'].scan(/Bearer (.*)$/).flatten.last
        token = JWT::Auth::Token.from_token jwt

        expect(token).to be_valid
      end
    end

    context 'disabled user' do
      let(:user) { User.new }

      it 'is not accessible without token' do
        get '/private'

        expect(response.status).to eq 401
      end

      it 'is not accessible with token' do
        get '/private', :headers => headers

        expect(response.status).to eq 401
      end
    end
  end
end
