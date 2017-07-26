# frozen_string_literal: true

require 'active_support/core_ext/numeric/time'

require 'jwt/auth/configuration'

module JWT
  module Auth
    ##
    # In-memory representation of JWT
    #
    class Token
      attr_accessor :expiration, :subject, :token_version

      def valid?
        # Reload subject to prevent caching the old token_version
        subject && subject.reload

        return false if subject.nil? || expiration.nil? || token_version.nil?
        return false if Time.at(expiration).past?
        return false if token_version != subject.token_version

        true
      rescue ActiveRecord::RecordNotFound
        false
      end

      def renew!
        self.expiration = nil
        self.token_version = nil
      end

      def to_jwt
        payload = {
          :exp => expiration || JWT::Auth.token_lifetime.from_now.to_i,
          :sub => subject.id,
          :ver => token_version || subject.token_version
        }
        JWT.encode payload, JWT::Auth.secret
      end

      def self.from_user(subject)
        token = JWT::Auth::Token.new
        token.subject = subject

        token
      end

      def self.from_token(token)
        begin
          payload = JWT.decode(token, JWT::Auth.secret).first
        rescue JWT::ExpiredSignature
          payload = {}
        end

        token = JWT::Auth::Token.new
        token.expiration = payload['exp']
        token.token_version = payload['ver']

        if payload['sub']
          find_method = JWT::Auth.model.respond_to?(:find_by_token) ? :find_by_token : :find_by
          token.subject = JWT::Auth.model.send find_method, :id => payload['sub'], :token_version => payload['ver']
        end

        token
      end
    end
  end
end
