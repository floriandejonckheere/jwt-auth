# frozen_string_literal: true

require 'jwt/auth/configuration'

module JWT
  module Auth
    ##
    # Controller methods
    #
    module Authentication
      ##
      # Current user helper
      #
      def current_user
        token&.subject
      end

      ##
      # Authenticate a request
      #
      def authenticate_user
        return head :unauthorized unless token&.valid?

        # Regenerate token (renews expiration date)
        add_token_to_response
      end

      ##
      # Add JWT header to response
      #
      def add_token_to_response
        token.renew!
        response.headers['Authorization'] = "Bearer #{token.to_jwt}"
      end

      protected

      ##
      # Extract JWT from request
      #
      def token
        return @token if @token

        header = request.env['HTTP_AUTHORIZATION']
        return nil unless header

        token = header.scan(/Bearer (.*)$/).flatten.last
        return nil unless token

        @token = JWT::Auth::Token.from_token token
      rescue JWT::DecodeError
        nil
      end
    end
  end
end
