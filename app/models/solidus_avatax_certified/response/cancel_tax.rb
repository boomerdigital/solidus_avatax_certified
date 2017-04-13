module SolidusAvataxCertified
  module Response
    class CancelTax < SolidusAvataxCertified::Response::Base

      def initialize(tax_result)
        @tax_result = tax_result['CancelTaxResult']
      end

    end
  end
end
