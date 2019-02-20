# frozen_string_literal: true

require 'jwt/auth/configuration'

module JWT
  module Auth
    ##
    # JWT refresh token
    #
    class RefreshToken < Token
      def type
        :refresh
      end

      def lifetime
        JWT::Auth.refresh_token_lifetime
      end
    end
  end
end
