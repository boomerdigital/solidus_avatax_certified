require 'logger'

Spree::Order.class_eval do

  has_one :avalara_transaction, dependent: :destroy

  self.state_machine.before_transition :to => :canceled,
                                      :do => :cancel_avalara,
                                      :if => :avalara_tax_enabled?
  self.state_machine.before_transition :to => :delivery,
                                      :do => :validate_ship_address,
                                      :if => :address_validation_enabled?

  def avalara_tax_enabled?
    Spree::AvalaraPreference.tax_calculation.is_true?
  end

  def cancel_avalara
    return nil unless avalara_transaction.present?
    self.avalara_transaction.cancel_order
  end

  def avalara_capture
    logger.debug 'avalara capture'

    create_avalara_transaction if avalara_transaction.nil?
    line_items.reload

    @rtn_tax = self.avalara_transaction.commit_avatax('SalesOrder')

    logger.info_and_debug('tax amount', @rtn_tax)
    @rtn_tax
  end

  def avalara_capture_finalize
    logger.debug 'avalara capture finalize'

    create_avalara_transaction if avalara_transaction.nil?
    line_items.reload

    @rtn_tax = avalara_transaction.commit_avatax_final('SalesInvoice')

    logger.info_and_debug('tax amount', @rtn_tax)
    @rtn_tax
  end

  def validate_ship_address
    avatax_address = SolidusAvataxCertified::Address.new(self)
    response = avatax_address.validate

    return response if response['ResultCode'] == 'Success'
    return response if !Spree::AvalaraPreference.refuse_checkout_address_validation_error.is_true?

    messages = response['Messages'].each do |message|
      errors.add(:address_validation_failure, message['Summary'])
    end
   return false
  end

  def avatax_cache_key
    key = ['Spree::Order']
    key << self.number
    key << self.promo_total
    key.join('-')
  end

  def customer_usage_type
    user ? user.avalara_entity_use_code.try(:use_code) : ''
  end

  def address_validation_enabled?
    return false if ship_address.nil?

    ship_address.validation_enabled?
  end

  def logger
    @logger ||= SolidusAvataxCertified::AvataxLog.new('avalara_order', 'order class', 'start order processing')
  end
end
