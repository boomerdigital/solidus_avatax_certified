module SolidusAvataxCertified
  module Request
    class ReturnTax < SolidusAvataxCertified::Request::Base

      def initialize(order, opts={})
        super
        @refund = opts[:refund]
      end

      def generate
        {
          createTransactionModel: {
            code: order.number.to_s + '.' + @refund.id.to_s,
            date: Date.today.strftime('%F'),
            commit: @commit,
            type: @doc_type ? @doc_type : 'ReturnOrder',
            lines: refund_lines
          }.merge(base_tax_hash)
        }
      end

      protected

      def doc_date
        Date.today.strftime('%F')
      end

      def base_tax_hash
        super.merge(tax_override)
      end

      def tax_override
        {
          taxOverride: {
            type: 'TaxDate',
            reason: @refund.try(:reason).try(:name).limit(255) || 'Return',
            taxDate: order.completed_at.strftime('%F')
          }
        }
      end

      def refund_lines
        @refund_lines ||= SolidusAvataxCertified::Lines::Refund.new(order, @doc_type, @refund).lines
      end
    end
  end
end
