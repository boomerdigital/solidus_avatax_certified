# frozen_string_literal: true

module SolidusAvataxCertified
  module Spree
    module ShipmentDecorator
      def avatax_cache_key
        key = ['Spree::Shipment']
        key << id
        key << cost
        key << stock_location.try(:cache_key)
        key << promo_total
        key.join('-')
      end

      def avatax_line_code
        'FR'
      end

      def shipping_method_tax_code
        tax_code = shipping_method.tax_category.try(:tax_code)
        if tax_code.nil?
          ''
        else
          tax_code
        end
      end

      def tax_category
        selected_shipping_rate.try(:tax_rate).try(:tax_category) || shipping_method.try(:tax_category)
      end

      ::Spree::Shipment.prepend self
    end
  end
end
