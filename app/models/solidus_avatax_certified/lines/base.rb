module SolidusAvataxCertified
  module Lines
    class Base
      attr_reader :order, :lines, :refund
      include Spree::Tax::TaxHelpers

      def initialize(order, invoice_type, refund=nil)
        @order = order
        @invoice_type = invoice_type
        @refund = refund
        @lines = []
      end

      def build_lines
        raise 'Method needs to be implemented in subclass.'
      end

      def get_stock_location(li)
        inventory_units = li.inventory_units

        return default_ship_from if inventory_units.blank?

        stock_loc = inventory_units.first.try(:shipment).try(:stock_location)

        stock_loc.nil? ? {} : stock_loc.to_avatax_hash
      end

      def ship_to
        order.ship_address.to_avatax_hash
      end

      def default_ship_from
        Spree::StockLocation.order_default.first.to_avatax_hash
      end

      private

      def base_line_hash
        @base_line_hash ||= {
          customerUsageType: order.customer_usage_type,
          businessIdentificationNo: business_id_no,
          exemptionCode: order.user.try(:exemption_number)
        }
      end

      def business_id_no
        order.user.try(:vat_id)
      end

      def discounted?(line_item)
        line_item.adjustments.promotion.eligible.any? || order.adjustments.promotion.eligible.any?
      end

      def tax_included_in_price?(item)
        !!rates_for_item(item).try(:first)&.included_in_price
      end
    end
  end
end
