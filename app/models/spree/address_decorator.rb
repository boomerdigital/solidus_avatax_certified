Spree::Address.class_eval do
  def validation_enabled?
    Spree::AvalaraPreference.address_validation.is_true? && country_validation_enabled?
  end

  def country_validation_enabled?
    Spree::Address.validation_enabled_countries.include?(country.try(:name))
  end

  def self.validation_enabled_countries
    Spree::AvalaraPreference.validation_enabled_countries_array
  end
end
