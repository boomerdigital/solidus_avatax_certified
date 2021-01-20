# frozen_string_literal: true

# DO NOT MODIFY FILE
AVATAX_CLIENT_VERSION = "a0o33000004FH8l"
AVATAX_HEADERS = { 'X-Avalara-UID' => AVATAX_CLIENT_VERSION }.freeze

require 'spree/avatax_configuration'

module Spree
  module Avatax
    Config = Spree::AvataxConfiguration.new
  end
end
