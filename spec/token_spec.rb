# frozen_string_literal: true

RSpec.describe JWT::Auth::Token do
  let(:user) { User.create! :activated => true }
  let(:token) { JWT::Auth::Token.from_user user }

  describe 'properties' do
    let(:token) { JWT::Auth::Token.from_user user }

    it 'has an issued at' do
      expect(token).to respond_to :issued_at
      expect(token.issued_at).to be_nil
    end

    it 'has a subject' do
      expect(token).to respond_to :subject
      expect(token.subject).to eq user
    end

    it 'has a token_version' do
      expect(token).to respond_to :token_version
      expect(token.token_version).to be_nil
    end
  end

  describe 'valid?' do
    it 'is invalid without subject' do
      jwt = token.to_jwt

      user.destroy

      t = JWT::Auth::Token.from_token jwt

      expect(t).not_to be_valid
    end

    it 'is invalid without subject 2' do
      t = JWT::Auth::Token.from_token token.to_jwt

      user.destroy

      expect(t).not_to be_valid
    end

    it 'is invalid on token_version increment' do
      t = JWT::Auth::Token.from_token token.to_jwt

      expect(t).to be_valid

      user.increment_token_version!
      user.reload

      expect(t).not_to be_valid
    end

    it 'is invalid on past date' do
      token.issued_at = (JWT::Auth.token_lifetime + 1.second).ago.to_i

      t = JWT::Auth::Token.from_token token.to_jwt

      expect(t).not_to be_valid
    end

    it 'is invalid after expiry date' do
      token.issued_at = JWT::Auth.token_lifetime.ago.to_i
      sleep 2

      t = JWT::Auth::Token.from_token token.to_jwt

      expect(t).not_to be_valid
    end
  end

  describe 'renew!' do
    it 'renews a token' do
      old_jwt = token.to_jwt
      old_token = JWT::Auth::Token.from_token old_jwt

      expect(old_token).to be_valid

      sleep 2

      old_token.renew!

      new_jwt = old_token.to_jwt
      new_token = JWT::Auth::Token.from_token new_jwt

      expect(new_token).to be_valid
      expect(new_jwt).not_to eq old_jwt
      expect(new_token.issued_at).not_to eq old_token.issued_at
    end
  end

  describe 'from token' do
    let(:issued_at) { 1.second.ago.to_i }

    let(:jwt) do
      payload = {
        :iat => issued_at,
        :sub => user.id,
        :ver => user.token_version
      }
      JWT.encode payload, JWT::Auth.secret
    end

    let(:token) { JWT::Auth::Token.from_token jwt }

    it 'matches issued at' do
      expect(token.issued_at).to eq issued_at
    end

    it 'matches subject' do
      expect(token.subject.id).to eq user.id
      expect(token.subject.token_version).to eq user.token_version
    end
  end
end
