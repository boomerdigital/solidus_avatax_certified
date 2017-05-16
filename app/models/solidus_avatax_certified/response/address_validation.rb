module SolidusAvataxCertified
  module Response
    class AddressValidation < SolidusAvataxCertified::Response::Base
      alias :validation_result :result

      def description
        'Address Validation'
      end
    end
  end
end
