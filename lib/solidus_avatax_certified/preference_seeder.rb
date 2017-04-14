module SolidusAvataxCertified
  class PreferenceSeeder
    BOOLEAN_PREFERENCES = ['tax_calculation', 'document_commit', 'log', 'log_to_stdout', 'address_validation', 'refuse_checkout_address_validation_error', 'customer_can_validate', 'raise_exceptions'].freeze
    STORABLE_ENV_PREFERENCES = ['company_code', 'endpoint', 'account', 'license_key'].freeze

    class << self

      def seed!(print_messages=true)
        @print_messages = print_messages
        stored_env_prefs
        boolean_prefs
        enabled_countries_pref
        origin_address
      end

      protected

      def stored_env_prefs
        STORABLE_ENV_PREFERENCES.each do |env|
          if !ENV["AVATAX_#{env.upcase}"].blank?
            value = ENV["AVATAX_#{env.upcase}"]
          else
            value = nil
          end

          pref = Spree::AvalaraPreference.new(name: env, value: value, object_type: 'string')

          save_preference(pref)
        end
      end

      def boolean_prefs
        BOOLEAN_PREFERENCES.each do |preference|
          if ['refuse_checkout_address_validation_error', 'log_to_stdout', 'raise_exceptions'].include?(preference)
            pref = Spree::AvalaraPreference.new(name: preference, value: 'false', object_type: 'boolean')
          else
            pref = Spree::AvalaraPreference.new(name: preference, value: 'true', object_type: 'boolean')
          end

          save_preference(pref)
        end
      end

      def enabled_countries_pref
        pref = Spree::AvalaraPreference.new(name: 'address_validation_enabled_countries', value: 'United States,Canada', object_type: 'array')
        save_preference(pref)
      end

      def origin_address
        pref = Spree::AvalaraPreference.find_or_create_by(name: 'origin_address', object_type: 'json')
        pref.value = "{}" if pref.value.nil?

        save_preference(pref)
      end

      def save_preference(preference)
        if preference.save
          success_message(preference) if @print_messages
        else
          puts "#{preference.errors.full_messages.to_sentence}"
        end
      end

      def success_message(preference)
        puts "Created: #{preference.name} - #{preference.value ? preference.value : 'Please input value in avalara settings!'}"
      end
    end
  end
end
