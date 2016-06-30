class MyConfigPreferences
  def self.set_preferences
    SolidusAvataxCertified::PreferenceSeeder.seed!(false)
    Spree::AvalaraPreference.origin_address.update_attributes(value: "{\"Address1\":\"915 S Jackson St\",\"Address2\":\"\",\"City\":\"Montgomery\",\"Region\":\"Alabama\",\"Zip5\":\"36104\",\"Zip4\":\"\",\"Country\":\"US\"}")
  end
end
