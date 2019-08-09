# frozen_string_literal: true

module SolidusAvataxCertified
  module Spree
    module AdjustmentDecorator
      def avatax_cache_key
        key = ['Spree::Adjustment']
        key << id
        key << amount
        key.join('-')
      end

      ::Spree::Adjustment.prepend self
    end
  end
end
