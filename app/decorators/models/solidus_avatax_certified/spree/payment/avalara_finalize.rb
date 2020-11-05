# frozen_string_literal: true

module SolidusAvataxCertified
  module Spree
    module Payment
      module AvalaraFinalize
        def self.prepended(base)
          base.state_machine.after_transition to: :completed, do: :avalara_finalize
          base.state_machine.after_transition to: :void, do: :cancel_avalara
        end

        def avalara_tax_enabled?
          ::Spree::Avatax::Config.tax_calculation
        end

        def cancel_avalara
          order.avalara_transaction&.cancel_order
        end

        def avalara_finalize
          return unless avalara_tax_enabled?

          order.avalara_capture_finalize
        end
      end
    end
  end
end

Spree::Payment.prepend SolidusAvataxCertified::Spree::Payment::AvalaraFinalize
