# frozen_string_literal: true

module SolidusAvataxCertified
  class PreferenceSeeder
    class << self
      def seed!(print_messages = true)
        ::Spree::Deprecation.warn(
          "#{name}#seed! has been deprecated.\n" \
          "Please refer to our updated setup guide: " \
          "https://github.com/boomerdigital/solidus_avatax_certified/wiki/Installation"
        )

        # maintain the previous behaviour: (re)set the config to default values
        ::Spree::Avatax::Config.reset
      end
    end
  end
end
