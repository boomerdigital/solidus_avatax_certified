# frozen_string_literal: true

module SolidusAvataxCertified
  module Spree
    module UserDecorator
      def self.prepended(base)
        base.belongs_to :avalara_entity_use_code, optional: true
      end

      ::Spree::LegacyUser.prepend self
    end
  end
end
