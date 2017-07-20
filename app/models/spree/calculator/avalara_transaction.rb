module Spree
  class Calculator::AvalaraTransaction < Calculator::DefaultTax
    def self.description
      Spree.t(:avalara_transaction_calculator)
    end

    def compute_order(order)
      raise 'Spree::AvalaraTransaction is designed to calculate taxes at the shipment and line-item levels.'
    end

    def compute_shipment_or_line_item(item)
      order = item.order

      if can_calculate_tax?(order)
        avalara_response = get_avalara_response(order)
        tax_for_item(item, avalara_response)
      else
        prev_tax_amount(item)
      end
    end

    alias_method :compute_shipment, :compute_shipment_or_line_item
    alias_method :compute_line_item, :compute_shipment_or_line_item

    def compute_shipping_rate(shipping_rate)
      return 0
    end

    private

    def prev_tax_amount(item)
      if rate.included_in_price
        item.included_tax_total
      else
        item.additional_tax_total
      end
    end

    # Tax Adjustments are not created or calculated until on payment page.
    # 1. We do not want to calculate tax until address is filled in and shipment type has been selected.
    # 2. VAT tax adjustments set included on adjustment creation, if the tax initially returns 0, included is set to false causing incorrect calculations.
    def can_calculate_tax?(order)
      address = order.tax_address

      return false unless Spree::Avatax::Config.tax_calculation
      return false if %w(address cart delivery).include?(order.state)
      return false if address.nil?
      return false unless calculable.zone.include?(address)

      true
    end

    def get_avalara_response(order)
      Rails.cache.fetch(cache_key(order), time_to_idle: 5.minutes) do
        if order.can_commit?
          order.avalara_capture_finalize
        else
          order.avalara_capture
        end
      end
    end


    def long_cache_key(order)
      key = order.avatax_cache_key
      key << order.tax_address.try(:cache_key)
      order.line_items.each do |line_item|
        key << line_item.avatax_cache_key
      end
      order.shipments.each do |shipment|
        key << shipment.avatax_cache_key
      end
      order.all_adjustments.non_tax do |adj|
        key << adj.avatax_cache_key
      end
      key
    end

    # long keys blow up in dev with the default ActiveSupport::Cache::FileStore
    # This transparently shrinks 'em
    def cache_key(order)
      long_key   = long_cache_key(order)
      short_key  = Digest::SHA1.hexdigest(long_key)
      "avtx_#{short_key}"
    end

    def tax_for_item(item, avalara_response)
      prev_tax_amount = prev_tax_amount(item)

      return prev_tax_amount if avalara_response.nil?
      return 0 if avalara_response[:totalTax] == 0.0

      avalara_response['lines'].each do |line|
        if line['lineNumber'] == "#{item.id}-#{item.avatax_line_code}"
          return line['taxCalculated']
        end
      end
      0
    end
  end
end
