require 'spec_helper'

describe Spree::Shipment, type: :model do
  describe '#avatax_cache_key' do
    it 'should respond with a cache key' do
      shipment = create(:shipment, id: 1, cost: 10.0, promo_total: 0.0)

      expected_response = "Spree::Shipment-1-10.0-#{shipment.stock_location.cache_key}-0.0"

      expect(shipment.avatax_cache_key).to eq(expected_response)
    end
  end

  describe '#avatax_line_code' do
    it 'should equal FR' do
      shipment = create(:shipment)

      expect(shipment.avatax_line_code).to eq('FR')
    end
  end

  describe '#shipping_method_tax_code' do
    it 'should return tax code' do
      shipment = create(:shipment)

      expect(shipment.shipping_method_tax_code).to eq('FR000000')
    end
  end
end
