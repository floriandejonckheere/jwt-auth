# frozen_string_literal: true

require 'active_support/core_ext/numeric/time'

require 'jwt/auth/configuration'

module JWT
  module Auth
    ##
    # In-memory representation of JWT
    #
    class Token
      attr_accessor :expiration, :subject

      def valid?
        !subject.nil? && !expiration.nil? && Time.at(expiration).future?
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

      def self.from_user(subject)
        token = JWT::Auth::Token.new
        token.subject = subject

        token
      end

      def self.from_token(token)
        payload = JWT.decode(token, JWT::Auth.secret).first

        token = JWT::Auth::Token.new
        token.expiration = payload['exp']

        find_method = JWT::Auth.model.respond_to?(:find_by_token) ? :find_by_token : :find_by
        token.subject = JWT::Auth.model.send find_method, :id => payload['sub'], :token_version => payload['ver']

        token
      end
    end
  end
end
