require 'spec_helper'

RSpec.describe SolidusAvataxCertified::OrderAdjuster, :vcr do
  subject(:adjuster) { described_class.new(order) }

  describe '#adjust!' do
    context 'before payment state' do
      let(:line_item) { build_stubbed(:line_item) }
      let(:shipment) { build_stubbed(:shipment) }
      let(:order) { build_stubbed(:order, state: 'delivery', line_items: [line_item], shipments: [shipment]) }

      it 'does not create new tax adjustments' do
        expect{ adjuster.adjust! }.to_not change { Spree::Adjustment.count }
      end

      it 'returns an array of all line items and shipments' do
        expect(adjuster.adjust!).to include(line_item)
        expect(adjuster.adjust!).to include(shipment)
      end
    end

    context 'at & after payment state' do
      let(:order) { create(:avalara_order) }

      before do
        order.reload # Allow order to create
        order.line_items.update_all(price: 20)
      end

      it 'updates the adjustments' do
        expect(order.state).to eq('payment')
        expect{ adjuster.adjust! }.to change { order.line_items.first.adjustments.tax.first.amount }.from(0.4).to(0.8)
      end
    end
  end
end
