module SolidusAvataxCertified
  module Request
    class Base
      attr_reader :order, :request

      def initialize(order, opts={})
        @order = order
        @doc_type = opts[:doc_type]
        @commit = opts[:commit]
        @request = {}
      end

      def generate
        raise 'Method needs to be implemented in subclass.'
      end

      protected

      def company_code
        @company_code ||= Spree::AvalaraPreference.company_code.value
      end

    end
  end
end
