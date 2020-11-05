# frozen_string_literal: true

module SolidusAvataxCertified
  module Spree
    module LineItem
      module AvataxHash
        def to_hash
          {
            'Index' => id,
            'Name' => name,
            'ItemID' => sku,
            'Price' => price.to_s,
            'Qty' => quantity,
            'TaxCategory' => tax_category
          }
        end

        def avatax_cache_key
          key = ['Spree::LineItem']
          key << id
          key << quantity
          key << price
          key << promo_total
          key.join('-')
        end

        def avatax_line_code
          'LI'
        end

      end
    end
  end
end

Spree::LineItem.prepend SolidusAvataxCertified::Spree::LineItem::AvataxHash
