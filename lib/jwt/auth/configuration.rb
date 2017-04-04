# frozen_string_literal: true

module JWT
  module Auth
    class << self
      attr_accessor :model, :secret, :token_lifetime

      def configure
        yield JWT::Auth
      end
    end
  end
end
