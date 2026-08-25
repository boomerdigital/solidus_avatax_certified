# frozen_string_literal: true

module SolidusAvataxCertified
  class Line
    attr_reader :order, :lines
    include ::Spree::Tax::TaxHelpers

    def initialize(order, invoice_type, refund = nil)
      @order = order
      @invoice_type = invoice_type
      @lines = []
      @refund = refund
      @refunds = []
      build_lines
    end

    def build_lines
      if %w(ReturnInvoice ReturnOrder).include?(@invoice_type)
        refund_lines
      else
        item_lines_array
        shipment_lines_array
      end
    end

    def item_line(line_item)
      {
        number: "#{line_item.id}-LI",
        description: line_item.name[0..255],
        taxCode: line_item.tax_category.try(:tax_code) || '',
        itemCode: truncateLine(line_item.variant.sku),
        quantity: line_item.quantity,
        amount: netted_line_amount(line_item),
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
        itemCode: truncateLine(shipment.shipping_method.name),
        quantity: 1,
        amount: shipment.total_before_tax.to_f,
        description: 'Shipping Charge',
        taxCode: shipment.shipping_method_tax_code,
        taxIncluded: tax_included_in_price?(shipment),
        addresses: {
          shipFrom: shipment.stock_location.to_avatax_hash,
          shipTo: ship_to
        }
      }.merge(base_line_hash)
    end

    def refund_lines
      return lines << refund_line if @refund.reimbursement.nil?

      return_items = @refund.reimbursement.customer_return.return_items
      inventory_units = ::Spree::InventoryUnit.where(id: return_items.pluck(:inventory_unit_id))

      inventory_units.group_by(&:line_item_id).each_value do |inv_unit|
        inv_unit_ids = inv_unit.map(&:id)
        return_items = ::Spree::ReturnItem.where(inventory_unit_id: inv_unit_ids)
        quantity = inv_unit.uniq.count

        amount = if return_items.first.respond_to?(:amount)
                   return_items.sum(:amount)
                 else
                   return_items.sum(:pre_tax_amount)
                 end

        lines << return_item_line(inv_unit.first.line_item, quantity, amount)
      end

      return_shipment_lines(inventory_units)
    end

    def return_shipment_lines(inventory_units)
      inventory_units.map(&:shipment).uniq.compact.each do |shipment|
        next unless shipment.tax_category

        lines << return_shipment_line(shipment)
      end
    end

    def return_shipment_line(shipment)
      {
        number: "#{shipment.id}-FR",
        itemCode: truncateLine(shipment.shipping_method.name),
        quantity: 1,
        amount: -shipment.total_before_tax.to_f,
        description: 'Shipping Charge',
        taxCode: shipment.shipping_method_tax_code,
        addresses: {
          shipFrom: shipment.stock_location.to_avatax_hash,
          shipTo: ship_to
        }
      }.merge(base_line_hash)
    end

    def refund_line
      {
        number: "#{@refund.id}-RA",
        itemCode: truncateLine(@refund.transaction_id) || 'Refund',
        quantity: 1,
        amount: -@refund.amount.to_f,
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
        itemCode: truncateLine(line_item.variant.sku),
        quantity: quantity,
        amount: -amount.to_f,
        addresses: {
          shipFrom: get_stock_location(line_item),
          shipTo: ship_to
        }
      }.merge(base_line_hash)
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
      ::Spree::StockLocation.order_default.first.to_avatax_hash
    end

    def truncateLine(line)
      return if line.nil?

      line.truncate(50)
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

    # The amount sent to AvaTax for a line, with all discounts netted in so tax
    # is computed on the post-discount price (per Avalara: "standard discounts
    # included in line-level extended amount"). Line-level discounts are already
    # reflected in #total_before_tax; order-level discounts are distributed across
    # the item lines proportionally by amount and subtracted here.
    def netted_line_amount(line_item)
      (line_item.total_before_tax + order_level_discount_for(line_item)).to_f
    end

    def order_level_discount_for(line_item)
      return BigDecimal(0) if order_level_discount_total.zero?

      -order_discount_handler.amount(line_item)
    end

    # Order-level (adjustable is the order itself) eligible, non-tax, negative
    # adjustments. The new solidus_promotions system has none of these — every
    # benefit attaches to a line item or shipment — so this only fires for legacy
    # order-level promotions and manual order discounts.
    def order_level_discount_total
      @order_level_discount_total ||=
        order.adjustments.eligible.reject(&:tax?).select { |a| a.amount.negative? }.sum(&:amount)
    end

    def order_discount_handler
      @order_discount_handler ||=
        ::Spree::DistributedAmountsHandler.new(order.line_items, order_level_discount_total.abs)
    end

    def tax_included_in_price?(item)
      !!rates_for_item(item).try(:first)&.included_in_price
    end
  end
end
