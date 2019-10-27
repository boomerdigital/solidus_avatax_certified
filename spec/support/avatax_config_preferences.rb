# frozen_string_literal: true

class MyConfigPreferences
  def self.set_preferences
    Spree::Avatax::Config.reset

    Spree::Avatax::Config.configure do |config|
      config.company_code = 'DEFAULT'
      config.license_key = '12345'
      config.account = '12345'

      config.refuse_checkout_address_validation_error = false
      config.log_to_stdout = false
      config.raise_exceptions = false
      config.log = true
      config.address_validation = true
      config.tax_calculation = true
      config.document_commit = true
      config.customer_can_validate = true

      config.address_validation_enabled_countries = ['United States', 'Canada']

      config.origin = "{\"line1\":\"915 S Jackson St\",\"line2\":\"\",\"city\":\"Montgomery\",\"region\":\"AL\",\"postalCode\":\"36104\",\"country\":\"US\"}"
    end
  end
end

RSpec.configure do |config|
  config.before do
    MyConfigPreferences.set_preferences
  end
end
