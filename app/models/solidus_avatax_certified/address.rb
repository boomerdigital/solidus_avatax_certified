# frozen_string_literal: true

require 'json'
require 'net/http'
require 'base64'
require 'logger'

module SolidusAvataxCertified
  class Address
    attr_reader :order, :addresses

    def initialize(order)
      @order = order
      @ship_address = order.ship_address
      @origin_address = JSON.parse(::Spree::Avatax::Config.origin)
      @addresses = {}

      build_addresses
    end

    def build_addresses
      origin_address
      order_ship_address unless @ship_address.nil?
    end

    def origin_address
      # I'm not sure if we want to pass this to the request.
      addresses[:pointOfOrderAcceptance] = {
        line1: @origin_address['line1'],
        line2: @origin_address['line2'],
        city: @origin_address['city'],
        region: @origin_address['region'],
        country: @origin_address['country'],
        postalCode: @origin_address['postalCode']
      }
    end

    def order_ship_address
      addresses[:shipTo] = @ship_address.to_avatax_hash
    end

    def validate
      return 'Address validation disabled' unless @ship_address.validation_enabled?
      return @ship_address if @ship_address.nil?

      validation_response(@ship_address.to_avatax_hash)
    end

    def get_hts_code(code)
      tax_svc = TaxSvc.new

      tax_svc.get_hts_code(@ship_address.country.iso, code)
    end

    private

    def validation_response(address)
      validator = TaxSvc.new
      validator.validate_address(address)
    end
  end
end
