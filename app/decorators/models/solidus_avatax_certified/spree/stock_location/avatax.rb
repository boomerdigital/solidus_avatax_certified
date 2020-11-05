# frozen_string_literal: true

module SolidusAvataxCertified
  module Spree
    module StockLocation
      module Avatax
        def self.prepended(base)
          base.include ToAvataxHash
        end

      end
    end
  end
end

Spree::StockLocation.prepend SolidusAvataxCertified::Spree::StockLocation::Avatax
