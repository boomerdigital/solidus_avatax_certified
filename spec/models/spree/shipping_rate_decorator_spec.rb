require 'spec_helper'

describe Spree::ShippingRate, type: :model do
  let!(:shipping_tax_category) { create(:tax_category, name: 'Shipping', tax_code: 'FR000000') }
  let!(:zone) { create(:zone, name: 'North America', zone_members: []) }
  let!(:tax_rate) { create(:tax_rate, tax_categories: [shipping_tax_category], amount: 0.00, included_in_price: false, zone: zone) }

  let(:shipment) { build(:shipment) }
  let(:shipping_method) { build(:shipping_method) }
  let(:shipping_rate) { Spree::ShippingRate.new(shipment: shipment, shipping_method: shipping_method, cost: 10, tax_rate_id: tax_rate.id) }

  describe '#tax_rate' do
    it 'returns the tax rate associated with shipping rate' do
      expect(shipping_rate.tax_rate).to eq(tax_rate)
    end
  end
end
