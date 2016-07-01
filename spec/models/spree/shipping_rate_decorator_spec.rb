require 'spec_helper'

describe Spree::ShippingRate, type: :model do
  let!(:shipping_tax_category) { Spree::TaxCategory.create(name: 'Shipping', tax_code: 'FR000000') }
  let!(:zone) { create(:zone, :name => 'North America', :default_tax => true, :zone_members => []) }
  let!(:tax_rate) { create(:tax_rate, :tax_category => shipping_tax_category, :amount => 0.00, :included_in_price => false, zone: zone) }

  describe '#tax_rate' do
    it 'returns the tax rate associated with shipping rate' do
      shipping_rate = create(:shipping_rate, tax_rate_id: tax_rate.id)
      expect(shipping_rate.tax_rate).to eq(tax_rate)
    end
  end
end
