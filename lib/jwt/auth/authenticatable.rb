# frozen_string_literal: true

require 'active_support/concern'

module JWT
  module Auth
    ##
    # User model methods
    #
    module Authenticatable
      extend ActiveSupport::Concern

      included do
        JWT::Auth.configure do |config|
          config.model = const_get name
        end
      end
    end
  end
end
