module SolidusAvataxCertified
  class PreferenceUpdater

    def initialize(params)
      @avatax_origin = params[:address]
      @avatax_preferences = params[:settings]
    end

    def update
      update_stored_preferences
      update_boolean_preferences
      update_validation_enabled_countries
      update_origin_address
    end

    private

    def update_stored_preferences
      Spree::AvalaraPreference.storable_envs.each do |preference|
        if !ENV.fetch("AVATAX_#{preference.name.upcase}").nil?
          update_value(preference, ENV["AVATAX_#{preference.name.upcase}"])
        else
          update_value(preference, @avatax_preferences[preference.name.downcase])
        end
      end
    end

    def update_boolean_preferences
      Spree::AvalaraPreference.booleans.each do |boolean|
        if !@avatax_preferences[boolean.name].nil?
          update_value(boolean, 'true')
        else
          update_value(boolean, 'false')
        end
      end
    end

    def update_origin_address
      update_value(Spree::AvalaraPreference.origin_address, @avatax_origin.to_json)
    end

    def update_validation_enabled_countries
      update_value(Spree::AvalaraPreference.validation_enabled_countries, @avatax_preferences['address_validation_enabled_countries'].join(','))
    end

    def update_value(preference, param)
      if value_changed?(preference, param)
        preference.update_attributes(value: param)
      end
    end

    def value_changed?(preference, param)
      preference.value != param
    end
  end
end
