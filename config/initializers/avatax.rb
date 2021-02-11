# frozen_string_literal: true

# DO NOT MODIFY FILE
AVATAX_HEADERS = { 'X-Avalara-Client' => ENV.fetch('AVATAX_CLIENT_ID') }.freeze

module Spree
  module Avatax
    Config = Spree::AvataxConfiguration.new
  end
end

Spree::Avatax::Config.account = ENV['AVATAX_ACCOUNT'] if ENV['AVATAX_ACCOUNT']
Spree::Avatax::Config.license_key = ENV['AVATAX_LICENSE_KEY'] if ENV['AVATAX_LICENSE_KEY']
Spree::Avatax::Config.company_code = ENV['AVATAX_COMPANY_CODE'] if ENV['AVATAX_COMPANY_CODE']
