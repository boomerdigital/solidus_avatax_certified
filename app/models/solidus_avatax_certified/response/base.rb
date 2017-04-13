module SolidusAvataxCertified
  module Response
    class Base
      attr_reader :tax_result
      # To Do
      # 1. Create Response model specific to Address Validation
      # 2. Create way to display errors cleanly

      def initialize(tax_result)
        @tax_result = tax_result
      end

      def success?
        tax_result['ResultCode'] == 'Success'
      end

      def error?
        !success? rescue true
      end
    end
  end
end
