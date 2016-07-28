require 'logger'

Spree::Refund.class_eval do
  has_one :avalara_transaction
  after_create :avalara_capture_finalize, if: :avalara_eligible?

  def avalara_eligible?
    Spree::AvalaraPreference.iseligible.is_true?
  end

  def avalara_capture_finalize
    logger.debug 'avalara capture refund avalara_capture_finalize'
    begin
      avalara_transaction_refund = self.payment.order.avalara_transaction

      @rtn_tax = avalara_transaction_refund.commit_avatax_final('ReturnInvoice', self)

      logger.info 'tax amount'
      logger.debug @rtn_tax
      @rtn_tax
    rescue => e
      logger.debug e
      logger.debug 'error in avalara capture refund finalize'
    end
  end

  def logger
    @logger ||= SolidusAvataxCertified::AvataxLog.new('refund', 'refund class')
  end
end
