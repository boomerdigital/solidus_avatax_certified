# frozen_string_literal: true

module SolidusAvataxCertified
  module Spree
    module User
      module EntityUseCode
        def self.prepended(base)
          base.belongs_to :avalara_entity_use_code, optional: true
        end
      end
    end
  end
end

Spree::User.prepend SolidusAvataxCertified::Spree::User::EntityUseCode
