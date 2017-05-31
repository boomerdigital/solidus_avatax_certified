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
      @origin_address = JSON.parse(Spree::Avatax::Config.origin)
      @addresses = []

      build_addresses
    end

    def build_addresses
      origin_address
      order_ship_address unless @ship_address.nil?
      origin_ship_addresses
    end

    def origin_address
      addresses << {
        AddressCode: 'Orig',
        Line1: @origin_address['line1'],
        Line2: @origin_address['line2'],
        City: @origin_address['city'],
        Region: @origin_address['region'],
        PostalCode: @origin_address['postalCode'],
        Country: @origin_address['country']
      }
    end

    def order_ship_address
      addresses << {
        AddressCode: 'Dest',
        Line1: @ship_address.address1,
        Line2: @ship_address.address2,
        City: @ship_address.city,
        Region: @ship_address.state_name,
        Country: @ship_address.country.try(:iso),
        PostalCode: @ship_address.zipcode
      }
    end

    def origin_ship_addresses
      Spree::StockLocation.where(id: stock_loc_ids).each do |stock_location|
        addresses << {
          AddressCode: "#{stock_location.id}",
          Line1: stock_location.address1,
          Line2: stock_location.address2,
          City: stock_location.city,
          PostalCode: stock_location.zipcode,
          Country: stock_location.country.try(:iso)
        }
      end
    end

    def validate
      return 'Address validation disabled' unless @ship_address.validation_enabled?
      return @ship_address if @ship_address.nil?

      validation_response(@ship_address.to_avatax_hash)
    end

    private

    def validation_response(address)
      validator = TaxSvc.new
      validator.validate_address(address)
    end

    def stock_loc_ids
      order.shipments.pluck(:stock_location_id).uniq
    end
  end
end
