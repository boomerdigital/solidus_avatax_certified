# frozen_string_literal: true

module SolidusAvataxCertified
  module Request
    class Base
      attr_reader :order, :request

      def initialize(order, opts = {})
        @order = order
        @doc_type = opts[:doc_type]
        @commit = can_commit?(opts[:commit])
        @request = {}
      end

      def generate
        raise 'Method needs to be implemented in subclass.'
      end

      protected

      def base_tax_hash
        hash = {
          customerCode: customer_code,
          companyCode: company_code,
          customerUsageType: order.customer_usage_type,
          exemptionNo: order.user.try(:exemption_number),
          referenceCode: order.number,
          currencyCode: order.currency,
          businessIdentificationNo: business_id_no
        }
        hash[:reportingLocationCode] = reporting_location_code if reporting_location_code
        hash[:addresses] = header_addresses if header_addresses.present?
        hash
      end

      def header_addresses
        addresses = {}
        addresses[:pointOfOrderOrigin] = order.bill_address.to_avatax_hash if order.bill_address
        addresses[:shipTo] = order.ship_address.to_avatax_hash if order.ship_address
        addresses[:shipFrom] = origin_address if origin_address
        addresses
      end

      def origin_address
        return if ::Spree::Avatax::Config.origin.blank?

        origin = JSON.parse(::Spree::Avatax::Config.origin)
        {
          line1: origin['line1'],
          line2: origin['line2'],
          city: origin['city'],
          region: origin['region'],
          country: origin['country'],
          postalCode: origin['postalCode']
        }
      end

      def address_lines
        @address_lines ||= SolidusAvataxCertified::Address.new(order).addresses
      end

      def sales_lines
        @sales_lines ||= SolidusAvataxCertified::Line.new(order, @doc_type).lines
      end

      def company_code
        @company_code ||= ::Spree::Avatax::Config.company_code
      end

      def business_id_no
        order.user.try(:vat_id)
      end

      def can_commit?(commit)
        return commit unless order.can_commit?

        true
      end

      def customer_code
        order.user ? order.user.id : order.email
      end

      def reporting_location_code
        order.stock_locations.first&.code.presence
      end
    end
  end
end
