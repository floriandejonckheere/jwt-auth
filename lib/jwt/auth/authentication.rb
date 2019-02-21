# frozen_string_literal: true

require 'jwt/auth/configuration'

module JWT
  module Auth
    ##
    # Controller methods
    #
    module Authentication
      ##
      # Current user
      #
      def current_user
        token&.subject
      end

      ##
      # Validate a token (if it's present)
      #
      # Apply this before_action filter for every API action
      #
      # @raises JWT::Auth::UnauthorizedError if a token is present and invalid
      #
      def validate_token
        raise JWT::Auth::UnauthorizedError unless token.nil? || token&.valid?
      end

      ##
      # Authenticate the user with the token
      #
      # Apply this before_action filter for API actions that need a token to be present
      #
      def validate_access_token
        raise JWT::Auth::UnauthorizedError if header.nil? || !token.is_a?(AccessToken)
      end

      ##
      # Validate a refresh token
      #
      # Apply this before_action filter for the API token refresh action
      #
      # @raises JWT::Auth::UnauthorizedError unless a valid refresh token is present
      #
      def validate_refresh_token
        raise JWT::Auth::UnauthorizedError if header.nil? || !token.is_a?(RefreshToken)
      end

      ##
      # Set API token in the response
      #
      def set_access_token(user = current_user)
        set_header JWT::Auth::AccessToken.new(:subject => user)
      end

      ##
      # Set refresh token in the response
      #
      def set_refresh_token(user = current_user)
        set_header JWT::Auth::RefreshToken.new(:subject => user)
      end

      protected

      def token
        @token ||= JWT::Auth::Token.from_jwt header
      end

      ##
      # Extract token from request
      #
      def header
        header = request.env['HTTP_AUTHORIZATION']
        return nil unless header

        header.scan(/Bearer (.*)$/).flatten.last
      end

      ##
      # Set a token in the response
      #
      def set_header(token)
        response.headers['Authorization'] = "Bearer #{token.to_jwt}"
      end
    end
  end
end
