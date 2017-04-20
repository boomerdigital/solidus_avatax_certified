module Spree
  class Payment
    module Avalara
      extend ActiveSupport::Concern

      included do
        self.state_machine.before_transition to: :completed, do: :avalara_finalize
        self.state_machine.after_transition to: :void, do: :cancel_avalara
      end

      def avalara_tax_enabled?
        Spree::AvalaraPreference.tax_calculation.is_true?
      end

      def cancel_avalara
        order.avalara_transaction.cancel_order unless order.avalara_transaction.nil?
      end

      def avalara_finalize
        return unless avalara_tax_enabled?
        order.avalara_capture_finalize
      end
    end
  end
end
