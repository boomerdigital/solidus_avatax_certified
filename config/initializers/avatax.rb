AVATAX_CLIENT_VERSION = "a0o33000004FH8l"
AVATAX_SERVICEPATH_ADDRESS = '/1.0/address/'
AVATAX_SERVICEPATH_TAX = '/1.0/tax/'

module Spree
  module Avatax
    Config = Spree::AvataxConfiguration.new
  end
end

Spree::Avatax::Config.username = ENV['AVATAX_USERNAME'] if ENV['AVATAX_USERNAME']
Spree::Avatax::Config.password = ENV['AVATAX_PASSWORD'] if ENV['AVATAX_PASSWORD']
Spree::Avatax::Config.company_code = ENV['AVATAX_COMPANY_CODE'] if ENV['AVATAX_COMPANY_CODE']
Spree::Avatax::Config.account = ENV['AVATAX_ACCOUNT'] if ENV['AVATAX_ACCOUNT']
Spree::Avatax::Config.license_key = ENV['AVATAX_LICENSE_KEY'] if ENV['AVATAX_LICENSE_KEY']
Spree::Avatax::Config.endpoint = ENV['AVATAX_ENDPOINT'] if ENV['AVATAX_ENDPOINT']
