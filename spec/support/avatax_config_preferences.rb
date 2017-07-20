class MyConfigPreferences
  def self.set_preferences
    SolidusAvataxCertified::PreferenceSeeder.seed!(false)
    Spree::Avatax::Config.origin = "{\"line1\":\"915 S Jackson St\",\"line2\":\"\",\"city\":\"Montgomery\",\"region\":\"AL\",\"postalCode\":\"36104\",\"country\":\"US\"}"
  end
end
