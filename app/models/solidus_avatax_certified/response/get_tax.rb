module SolidusAvataxCertified
  module Response
    class GetTax < SolidusAvataxCertified::Response::Base
      alias :tax_result :result

      def description
        'Get Tax'
      end
    end
  end
end
