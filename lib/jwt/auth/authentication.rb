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
        jwt && jwt.subject
      end

      ##
      # Authenticate a request
      #
      def authenticate_user
        raise JWT::Auth::UnauthorizedError unless jwt && jwt.valid?
      end

      ##
      # Add JWT header to response
      #
      def renew_token
        return unless jwt && jwt.valid?
        jwt.renew!
        response.headers['Authorization'] = "Bearer #{jwt.to_jwt}"
      end

      protected

      ##
      # Extract JWT from request
      #
      def jwt
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
