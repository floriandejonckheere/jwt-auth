# frozen_string_literal: true

require 'jwt/auth/configuration'

module JWT
  module Auth
    ##
    # In-memory representation of JWT
    #
    class Token
      attr_accessor :issued_at,
                    :subject,
                    :version

      def initialize(params = {})
        params.each { |key, value| send "#{key}=", value }
      end

      def valid?
        # Reload subject to prevent caching the old token_version
        subject&.reload

        return false if subject.nil? || issued_at.nil? || version.nil?
        return false if Time.at(issued_at + lifetime.to_i).past?
        return false if Time.at(issued_at).future?
        return false if version != subject.token_version

        true
      rescue ActiveRecord::RecordNotFound
        false
      end

      def to_jwt
        JWT.encode payload, JWT::Auth.secret
      end

      ##
      # Override this method in subclasses
      #
      def type
        raise NotImplementedError
      end

      ##
      # Override this method in subclasses
      #
      def lifetime
        raise NotImplementedError
      end

      class << self
        def from_jwt(token)
          payload = JWT.decode(token, JWT::Auth.secret).first

          token = token_for payload['typ']

          return token ? token.new(parse payload) : nil
        rescue JWT::DecodeError
          nil
        end

        protected

        ##
        # Parse raw JWT payload into params object used to initialize a token class
        #
        def parse(payload)
          {
            :issued_at => payload['iat'],
            :version => payload['ver'],
            :subject => model.find_by_token(:id => payload['sub'],
                                            :token_version => payload['ver'])
          }
        end

        ##
        # Determine token class based on type identifier
        #
        def token_for(type)
          case type
          when 'access'
            AccessToken
          when 'refresh'
            RefreshToken
          else
            nil
          end
        end

        def model
          const_get JWT::Auth.model
        end
      end

      private

      def payload
        {
          :iat => issued_at || Time.now.to_i,
          :sub => subject.id,
          :ver => version || subject.token_version,
          :typ => type
        }
      end
    end
  end
end
