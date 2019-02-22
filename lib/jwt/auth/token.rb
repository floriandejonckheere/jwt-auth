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
        subject && subject.reload

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
          begin
            @decoded_payload = JWT.decode(token, JWT::Auth.secret).first
          rescue JWT::DecodeError
            @decoded_payload = {}
          end

          params = {
            :issued_at => @decoded_payload['iat'],
            :version => @decoded_payload['ver'],
            :subject => model.find_by_token(:id => @decoded_payload['sub'],
                                            :token_version => @decoded_payload['ver'])
          }

          case @decoded_payload['typ']
          when 'access'
            return AccessToken.new params
          when 'refresh'
            return RefreshToken.new params
          else
            return nil
          end
        end

        private

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
