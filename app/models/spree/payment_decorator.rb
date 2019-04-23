# frozen_string_literal: true

Spree::Payment.class_eval do
  state_machine.after_transition to: :completed, do: :avalara_finalize
  state_machine.after_transition to: :void, do: :cancel_avalara

  def avalara_tax_enabled?
    Spree::Avatax::Config.tax_calculation
  end

  def cancel_avalara
    order.avalara_transaction&.cancel_order
  end

  def avalara_finalize
    return unless avalara_tax_enabled?

    order.avalara_capture_finalize
  end
end
