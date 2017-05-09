class MyConfigPreferences
  def self.set_preferences
    SolidusAvataxCertified::PreferenceSeeder.seed!(false)
    Spree::Avatax::Config.origin = "{\"Line1\":\"915 S Jackson St\",\"Line2\":\"\",\"City\":\"Montgomery\",\"Region\":\"AL\",\"PostalCode\":\"36104\",\"Zip4\":\"\",\"Country\":\"US\"}"
  end
end
