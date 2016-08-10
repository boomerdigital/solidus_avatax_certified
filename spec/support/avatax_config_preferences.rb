class MyConfigPreferences
  def self.set_preferences
    SolidusAvataxCertified::PreferenceSeeder.seed!(false)
    Spree::AvalaraPreference.origin_address.update_attributes(value: "{\"Line1\":\"915 S Jackson St\",\"Line2\":\"\",\"City\":\"Montgomery\",\"Region\":\"AL\",\"PostalCode\":\"36104\",\"Zip4\":\"\",\"Country\":\"US\"}")
    Spree::AvalaraPreference.log_to_stdout.update_attributes(value: 'false')
    Spree::AvalaraPreference.refuse_checkout_address_validation_error.update_attributes(value: 'false')
  end
end
