module SolidusAvataxCertified
  module Request
    class GetTax < SolidusAvataxCertified::Request::Base
      def generate
        {
          createTransactionModel: {
            code: order.number,
            date: doc_date,
            discount: order.all_adjustments.promotion.eligible.sum(:amount).abs.to_s,
            commit: @commit,
            type: @doc_type ? @doc_type : 'SalesOrder',
            lines: sales_lines
          }.merge(base_tax_hash)
        }
      end

      def sales_lines
        @sales_lines ||= SolidusAvataxCertified::Lines::Sale.new(order, @doc_type).lines
      end

      protected

      def doc_date
        order.completed? ? order.completed_at.strftime('%F') : Date.today.strftime('%F')
      end
    end
  end
end
