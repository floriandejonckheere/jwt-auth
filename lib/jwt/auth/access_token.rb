# frozen_string_literal: true

require 'jwt/auth/configuration'

module JWT
  module Auth
    ##
    # JWT access token
    #
    class AccessToken < Token
      def type
        :access
      end

      def lifetime
        JWT::Auth.access_token_lifetime
      end
    end
  end
end
