# frozen_string_literal: true

module SolidusAvataxCertified
  module Spree
    module Adjustment
      module AvataxCacheKey
        def avatax_cache_key
          key = ['Spree::Adjustment']
          key << id
          key << amount
          key.join('-')
        end

      end
    end
  end
end

Spree::Adjustment.prepend SolidusAvataxCertified::Spree::Adjustment::AvataxCacheKey
