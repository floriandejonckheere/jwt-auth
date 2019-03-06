# frozen_string_literal: true

require 'yaml'

module JWT
  module Auth
    VERSION = YAML.load_file File.join __dir__, '..', '..', '..', 'version.yml'
  end
end
