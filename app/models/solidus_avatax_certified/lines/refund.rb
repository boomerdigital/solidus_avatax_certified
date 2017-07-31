module SolidusAvataxCertified
  module Lines
    class Refund < SolidusAvataxCertified::Lines::Base

      def initialize(order, invoice_type, refund)
        super
        build_lines
      end

      def build_lines
        refund_lines
      end

      def refund_lines
        return lines << refund_line if refund.reimbursement.nil?

        return_items = refund.reimbursement.customer_return.return_items
        inventory_units = Spree::InventoryUnit.where(id: return_items.pluck(:inventory_unit_id))

        inventory_units.group_by(&:line_item_id).each_value do |inv_unit|

          inv_unit_ids = inv_unit.map { |iu| iu.id }
          return_items = Spree::ReturnItem.where(inventory_unit_id: inv_unit_ids)
          quantity = inv_unit.uniq.count

          amount = if return_items.first.respond_to?(:amount)
            return_items.sum(:amount)
          else
            return_items.sum(:pre_tax_amount)
          end

          lines << return_item_line(inv_unit.first.line_item, quantity, amount)
        end
      end

      def refund_line
        {
          number: "#{refund.id}-RA",
          itemCode: refund.transaction_id || 'Refund',
          quantity: 1,
          amount: -refund.amount.to_f,
          description: 'Refund',
          taxIncluded: true,
          addresses: {
            shipFrom: default_ship_from,
            shipTo: ship_to
          }
        }.merge(base_line_hash)
      end

      def return_item_line(line_item, quantity, amount)
        {
          number: "#{line_item.id}-LI",
          description: line_item.name[0..255],
          taxCode: line_item.tax_category.try(:tax_code) || '',
          itemCode: line_item.variant.sku,
          quantity: quantity,
          amount: -amount.to_f,
          addresses: {
            shipFrom: get_stock_location(line_item),
            shipTo: ship_to
          }
        }.merge(base_line_hash)
      end
    end
  end
end
