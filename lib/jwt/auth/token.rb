# frozen_string_literal: true

# require 'active_support/core_ext/numeric/time'

require 'jwt/auth/configuration'

module JWT
  module Auth
    ##
    # In-memory representation of JWT
    #
    class Token
      attr_accessor :issued_at,
                    :subject,
                    :token_version,
                    :type

      def valid?
        # Reload subject to prevent caching the old token_version
        subject && subject.reload

        return false if subject.nil? || issued_at.nil? || token_version.nil? || type.nil?
        return false if Time.at(issued_at + lifetime.to_i).past?
        return false if Time.at(issued_at).future?
        return false if token_version != subject.token_version

        true
      rescue ActiveRecord::RecordNotFound
        false
      end

      def renew!
        self.issued_at = nil
        self.token_version = nil
      end

      def to_jwt
        JWT.encode payload, JWT::Auth.secret
      end

      def payload
        {
          :iat => issued_at || Time.now.to_i,
          :sub => subject.id,
          :ver => token_version || subject.token_version,
          :typ => type
        }
      end

      def lifetime
        if refresh?
          JWT::Auth.refresh_token_lifetime
        else
          JWT::Auth.request_token_lifetime
        end
      end

      def refresh?
        @type == 'refresh'
      end

      def request?
        @type == 'request'
      end

      def self.from_user(subject)
        token = self.new
        token.subject = subject

        token
      end

      def self.from_token(token)
        begin
          @decoded_payload = JWT.decode(token, JWT::Auth.secret).first
        rescue JWT::DecodeError
          @decoded_payload = {}
        end

        token = self.new
        token.issued_at = @decoded_payload['iat']
        token.token_version = @decoded_payload['ver']
        token.type = @decoded_payload['typ']

        if @decoded_payload['sub']
          find_method = JWT::Auth.model.respond_to?(:find_by_token) ? :find_by_token : :find_by
          token.subject = JWT::Auth.model.send find_method, :id => @decoded_payload['sub'], :token_version => @decoded_payload['ver']
        end

        token
      end
    end
  end
end
