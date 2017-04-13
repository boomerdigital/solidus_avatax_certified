require_dependency 'spree/order'

module Spree
  class AvalaraTransaction < Spree::Base
    belongs_to :order
    validates :order, presence: true
    validates :order_id, uniqueness: true

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
        logger.info 'Avalara Document Committing Disabled'
        'Avalara Document Committing Disabled'
      end
    end

    def cancel_order
      cancel_order_to_avalara('SalesInvoice') if tax_calculation_enabled?
    end

    private

    def cancel_order_to_avalara(doc_type = 'SalesInvoice')
      logger.info "Begin cancel order #{order.number} to avalara..."

      request = SolidusAvataxCertified::Request::CancelTax.new(order, doc_type: doc_type).generate

      mytax = TaxSvc.new
      cancel_tax_result = mytax.cancel_tax(request)

      if cancel_tax_result == 'Error in Cancel Tax'
        return 'Error in Cancel Tax'
      else
        return cancel_tax_result
      end
    end

    def post_order_to_avalara(commit = false, doc_type = nil)
      logger.info "Begin post order #{order.number} to avalara"

      request = SolidusAvataxCertified::Request::GetTax.new(order, commit: commit, doc_type: doc_type).generate

      mytax = TaxSvc.new
      tax_result = mytax.get_tax(request)

      return { TotalTax: '0.00' } if tax_result == 'error in Tax'
      return tax_result if tax_result['ResultCode'] == 'Success'
    end

    def post_return_to_avalara(commit = false, invoice_detail = nil, refund = nil)
      logger.info "Begin post return order #{order.number} to avalara"

      avatax_address = SolidusAvataxCertified::Address.new(order)
      avatax_line = SolidusAvataxCertified::Line.new(order, invoice_detail, refund)

      taxoverride = {
        TaxOverrideType: 'TaxDate',
        Reason: refund.try(:reason).try(:name).limit(255) || 'Return',
        TaxDate: order.completed_at.strftime('%F')
      }

      gettaxes = {
        DocCode: order.number.to_s + '.' + refund.id.to_s,
        DocDate: Date.today.strftime('%F'),
        Commit: commit,
        DocType: invoice_detail ? invoice_detail : 'ReturnOrder',
        Addresses: avatax_address.addresses,
        Lines: avatax_line.lines
      }.merge(base_tax_hash)

      if !business_id_no.blank?
        gettaxes[:BusinessIdentificationNo] = business_id_no
      end

      gettaxes[:TaxOverride] = taxoverride

      mytax = TaxSvc.new
      tax_result = mytax.get_tax(gettaxes)

      return { TotalTax: '0.00' } if tax_result == 'error in Tax'
      return tax_result if tax_result['ResultCode'] == 'Success'
    end

    def base_tax_hash
      {
        CustomerCode: customer_code,
        CompanyCode: Spree::AvalaraPreference.company_code.value,
        CustomerUsageType: order.customer_usage_type,
        ExemptionNo: order.user.try(:exemption_number),
        Client:  avatax_client_version,
        ReferenceCode: order.number,
        DetailLevel: 'Tax',
        CurrencyCode: order.currency
      }
    end

    def customer_code
      order.user ? order.user.id : order.email
    end

    def business_id_no
      order.user.try(:vat_id)
    end

    def avatax_client_version
      AVATAX_CLIENT_VERSION || 'a0o33000004FH8l'
    end

    def document_committing_enabled?
      Spree::AvalaraPreference.document_commit.is_true?
    end

    def tax_calculation_enabled?
      Spree::AvalaraPreference.tax_calculation.is_true?
    end

    def logger
      @logger ||= SolidusAvataxCertified::AvataxLog.new('Spree::AvalaraTransaction class')
    end
  end
end
