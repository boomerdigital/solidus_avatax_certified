# frozen_string_literal: true

module SolidusAvataxCertified
  module Spree
    module RefundDecorator
      def self.prepended(base)
        base.has_one :avalara_transaction
        base.after_create :avalara_capture_finalize, if: :avalara_tax_enabled?
      end

      def avalara_tax_enabled?
        ::Spree::Avatax::Config.tax_calculation
      end

      def avalara_capture_finalize
        logger.info "Start Spree::Refund#avalara_capture_finalize for order #{payment.order.number}"

        begin
          avalara_transaction_refund = payment.order.avalara_transaction

          @rtn_tax = avalara_transaction_refund.commit_avatax_final('ReturnInvoice', self)

          @rtn_tax
        rescue StandardError => e
          logger.error(e, 'Refund Capture Finalize Error')
        end
      end

      def logger
        @logger ||= SolidusAvataxCertified::AvataxLog.new('Spree::Refund class', 'Start refund capture')
      end

      ::Spree::Refund.prepend self
    end
  end
end
