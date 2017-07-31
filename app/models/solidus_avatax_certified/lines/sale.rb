module SolidusAvataxCertified
  module Lines
    class Sale < SolidusAvataxCertified::Lines::Base

      def initialize(order, invoice_type)
        super
        build_lines
      end

      def build_lines
        item_lines_array
        shipment_lines_array
      end

      def item_line(line_item)
        {
          number: "#{line_item.id}-LI",
          description: line_item.name[0..255],
          taxCode: line_item.tax_category.try(:tax_code) || '',
          itemCode: line_item.variant.sku,
          quantity: line_item.quantity,
          amount: line_item.amount.to_f,
          discounted: discounted?(line_item),
          taxIncluded: tax_included_in_price?(line_item),
          addresses: {
            shipFrom: get_stock_location(line_item),
            shipTo: ship_to
          }
        }.merge(base_line_hash)
      end

      def item_lines_array
        order.line_items.each do |line_item|
          lines << item_line(line_item)
        end
      end

      def shipment_lines_array
        order.shipments.each do |shipment|
          next unless shipment.tax_category
          lines << shipment_line(shipment)
        end
      end

      def shipment_line(shipment)
        {
          number: "#{shipment.id}-FR",
          itemCode: shipment.shipping_method.name,
          quantity: 1,
          amount: shipment.discounted_amount.to_f,
          description: 'Shipping Charge',
          taxCode: shipment.shipping_method_tax_code,
          discounted: false,
          taxIncluded: tax_included_in_price?(shipment),
          addresses: {
            shipFrom: shipment.stock_location.to_avatax_hash,
            shipTo: ship_to
          }
        }.merge(base_line_hash)
      end
    end
  end
end
