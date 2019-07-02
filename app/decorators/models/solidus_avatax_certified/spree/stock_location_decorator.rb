# frozen_string_literal: true

module SolidusAvataxCertified
  module Spree
    module StockLocationDecorator
      def self.prepended(base)
        base.include ToAvataxHash
      end

      ::Spree::StockLocation.prepend self
    end
  end
end
