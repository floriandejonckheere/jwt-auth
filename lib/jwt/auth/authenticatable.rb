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
        ##
        # Define model in jwt-auth configuration
        #
        JWT::Auth.configure do |config|
          config.model = name
        end

        ##
        # Token version validation
        #
        validates :token_version,
                  :presence => true

        ##
        # Dummy #find_by_token method
        #
        def find_by_token(*args)
          find_by args
        end
      end
    end
  end
end
