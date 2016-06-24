require 'logging'
require_dependency 'spree/order'

module Spree
  class AvalaraTransaction < Spree::Base
    belongs_to :order
    validates :order, presence: true
    validates :order_id, uniqueness: true
    # has_many :adjustments, as: :source

    def lookup_avatax
      post_order_to_avalara(false, 'SalesOrder')
    end

    def commit_avatax(invoice_dt = nil, refund = nil)
      if tax_calculation_enabled?
        if %w(ReturnInvoice ReturnOrder).include?(invoice_dt)
          post_return_to_avalara(false, invoice_dt, refund)
        else
          post_order_to_avalara(false, invoice_dt)
        end
      else
        { TotalTax: '0.00' }
      end
    end

    def commit_avatax_final(invoice_dt = nil, refund = nil)
      if document_committing_enabled?
        if tax_calculation_enabled?
          if %w(ReturnInvoice ReturnOrder).include?(invoice_dt)
            post_return_to_avalara(true, invoice_dt, refund)
          else
            post_order_to_avalara(true, invoice_dt)
          end
        else
          { TotalTax: '0.00' }
        end
      else
        logger.debug 'avalara document committing disabled'
        'avalara document committing disabled'
      end
    end

    def cancel_order
      cancel_order_to_avalara('SalesInvoice') if tax_calculation_enabled?
    end

    private

    def cancel_order_to_avalara(doc_type = 'SalesInvoice')
      logger.info('cancel order to avalara')

      cancel_tax_request = {
        CompanyCode: Spree::Config.avatax_company_code,
        DocType: doc_type,
        DocCode: order.number,
        CancelCode: 'DocVoided'
      }

      mytax = TaxSvc.new
      cancel_tax_result = mytax.cancel_tax(cancel_tax_request)

      logger.debug cancel_tax_result

      if cancel_tax_result == 'Error in Cancel Tax'
        return 'Error in Cancel Tax'
      else
        return cancel_tax_result
      end
    end

    def post_order_to_avalara(commit = false, invoice_detail = nil)
      logger.info('post order to avalara')
      avatax_address = SolidusAvataxCertified::Address.new(order)
      avatax_line = SolidusAvataxCertified::Line.new(order, invoice_detail)

      response = avatax_address.validate

      unless response.nil?
        if response['ResultCode'] == 'Success'
          logger.info('Address Validation Success')
        else
          logger.info('Address Validation Failed')
        end
      end

      gettaxes = {
        DocCode: order.number,
        Discount: order.adjustments.eligible.promotion.sum(:amount).abs.to_s,
        Commit: commit,
        DocType: invoice_detail ? invoice_detail : 'SalesOrder',
        Addresses: avatax_address.addresses,
        Lines: avatax_line.lines
      }.merge(base_tax_hash)

      logger.debug gettaxes

      mytax = TaxSvc.new

      tax_result = mytax.get_tax(gettaxes)

      logger.info_and_debug('tax result', tax_result)

      return { TotalTax: '0.00' } if tax_result == 'error in Tax'
      return tax_result if tax_result['ResultCode'] == 'Success'
    end

    def post_return_to_avalara(commit = false, invoice_detail = nil, refund = nil)
      logger.info('starting post return order to avalara')

      avatax_address = SolidusAvataxCertified::Address.new(order)
      avatax_line = SolidusAvataxCertified::Line.new(order, invoice_detail, refund)

      taxoverride = {
        TaxOverrideType: 'None',
        Reason: 'Return',
        TaxDate: order.completed_at.strftime('%F')
      }

      gettaxes = {
        DocCode: order.number.to_s + '.' + refund.id.to_s,
        Commit: commit,
        DocType: invoice_detail ? invoice_detail : 'ReturnOrder',
        Addresses: avatax_address.addresses,
        Lines: avatax_line.lines
      }.merge(base_tax_hash)

      gettaxes[:TaxOverride] = taxoverride

      logger.debug gettaxes

      mytax = TaxSvc.new

      tax_result = mytax.get_tax(gettaxes)

      logger.info_and_debug('tax result', tax_result)

      return { TotalTax: '0.00' } if tax_result == 'error in Tax'
      return tax_result if tax_result['ResultCode'] == 'Success'
    end

    def base_tax_hash
      doc_date = order.completed? ? order.completed_at.strftime('%F') : Date.today.strftime('%F')
      {
        CustomerCode: customer_code,
        DocDate: doc_date,
        CompanyCode: Spree::Config.avatax_company_code,
        CustomerUsageType: order.customer_usage_type,
        ExemptionNo: order.user.try(:exemption_number),
        Client:  avatax_client_version,
        ReferenceCode: order.number,
        DetailLevel: 'Tax'
      }
    end

    def customer_code
      order.user ? order.user.id : order.email
    end

    def avatax_client_version
      AVATAX_CLIENT_VERSION || 'SolidusV1.2.0-ExtV0.0.1'
    end

    def document_committing_enabled?
      Spree::Config.avatax_document_commit
    end

    def tax_calculation_enabled?
      Spree::Config.avatax_tax_calculation
    end

    def logger
      @logger ||= AvataxHelper::AvataxLog.new('post_order_to_avalara', __FILE__)
    end
  end
end
