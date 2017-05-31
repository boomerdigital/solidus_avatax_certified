module SolidusAvataxCertified
  module Response
    class CancelTax < SolidusAvataxCertified::Response::Base
      alias :tax_result :result

      def description
        'Cancel Tax'
      end

      def success?
        result['status'] == 'Cancelled'
      end
    end
  end
end
