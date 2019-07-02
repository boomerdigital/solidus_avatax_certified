# frozen_string_literal: true

module SolidusAvataxDecorator
  module Spree
    module ShippingRateDecorator
      def tax_rate
        ::Spree::TaxRate.find(tax_rate_id) if tax_rate_id
      end

      # Solidusv1.0-v1.2 uses display_amount while newer versions use display_base_price
      def display_price
        price = if respond_to?(:display_amount)
          display_amount
        else
          display_base_price
        end.to_s

        return price if ::Spree::Avatax::Config.tax_calculation
        return price if taxes.empty? || amount == 0

        tax_explanations = taxes.map(&:label).join(tax_label_separator)

        ::Spree.t :display_price_with_explanations,
          scope: 'shipping_rate.display_price',
          price: price,
          explanations: tax_explanations
      end
      alias_method :display_cost, :display_price

      ::Spree::ShippingRate.prepend self
    end
  end
end
