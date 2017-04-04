# frozen_string_literal: true

require 'active_support/core_ext/numeric/time'

require 'jwt/auth/configuration'

module JWT
  module Auth
    class Token
      attr_accessor :expiration, :subject

      def valid?
        subject && Time.at(expiration).future?
      end

      def renew!
        self.expiration = nil
      end

      def to_jwt
        payload = {
          :exp => expiration || JWT::Auth.token_lifetime.from_now.to_i,
          :sub => subject.id,
          :ver => subject.token_version
        }
        JWT.encode payload, JWT::Auth.secret
      end

      def self.from_token(token)
        payload = JWT.decode(token, JWT::Auth.secret).first

        token = JWT::Auth::Token.new
        token.expiration = payload['exp']
        token.subject = JWT::Auth.model.find_by :id => payload['sub'], :token_version => payload['ver']
      end
    end
  end
end
