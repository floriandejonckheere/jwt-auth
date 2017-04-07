# frozen_string_literal: true

module JWT
  module Auth
    class Error < StandardError; end

    class UnauthorizedError < Error; end
  end
end
