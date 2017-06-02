# DO NOT MODIFY FILE
AVATAX_CLIENT_VERSION = "a0o33000004FH8l"
AVATAX_HEADERS = { 'X-Avalara-UID' => AVATAX_CLIENT_VERSION }

module Spree
  module Avatax
    Config = Spree::AvataxConfiguration.new
  end
end

Spree::Avatax::Config.username = ENV['AVATAX_USERNAME'] if ENV['AVATAX_USERNAME']
Spree::Avatax::Config.password = ENV['AVATAX_PASSWORD'] if ENV['AVATAX_PASSWORD']
Spree::Avatax::Config.company_code = ENV['AVATAX_COMPANY_CODE'] if ENV['AVATAX_COMPANY_CODE']
