module SolidusAvataxCertified
  module Response
    class AddressValidation < SolidusAvataxCertified::Response::Base
      attr_reader :validation_result

      def initialize(validation_result)
        @validation_result = JSON.parse(validation_result)
      end

    end
  end
end
