require 'spec_helper'

RSpec.describe SolidusAvataxCertified::Lines::Sale do
  let(:order) { create(:order_with_line_items, line_items_count: 2) }
  subject { described_class.new(order, 'SalesOrder') }

  describe '#initialize' do
    it 'should have order' do
      expect(subject.order).to eq(order)
    end
    it 'should have lines be an array' do
      expect(subject.lines).to be_kind_of(Array)
    end
    it 'lines should be a length of 2' do
      expect(subject.lines.length).to eq(2)
    end
  end

  context 'sales order' do
    describe '#build_lines' do
      it 'receives method item_lines_array' do
        expect(subject).to receive(:item_lines_array)
        subject.build_lines
      end
      it 'receives method shipment_lines_array' do
        expect(subject).to receive(:shipment_lines_array)
        subject.build_lines
      end
    end

    describe '#item_lines_array' do
      it 'returns an Array' do
        expect(subject.item_lines_array).to be_kind_of(Array)
      end
    end

    describe '#shipment_lines_array' do
      it 'returns an Array' do
        expect(subject.shipment_lines_array).to be_kind_of(Array)
      end
      it 'should have a length of 1' do
        expect(subject.shipment_lines_array.length).to eq(1)
      end
    end

    describe '#item_line' do
      it 'returns a Hash with correct keys' do
        expect(subject.item_line(order.line_items.first)).to be_kind_of(Hash)
        expect(subject.item_line(order.line_items.first)[:number]).to be_present
      end
    end
    describe '#shipment_line' do
      it 'returns a Hash with correct keys' do
        expect(subject.shipment_line(order.shipments.first)).to be_kind_of(Hash)
        expect(subject.shipment_line(order.shipments.first)[:number]).to be_present
      end
    end
  end
end
