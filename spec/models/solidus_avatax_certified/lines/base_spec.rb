require 'spec_helper'

RSpec.describe SolidusAvataxCertified::Lines::Base do
  let(:order) { create(:order_with_line_items) }
  subject { described_class.new(order, 'SalesOrder') }

  describe '#build_lines' do
    it 'raises error' do
      expect{ subject.build_lines }.to raise_error('Method needs to be implemented in subclass.')
    end
  end

  describe '#get_stock_location' do
    it 'returns a hash' do
      expect(subject.get_stock_location(order.line_items.first)).to be_kind_of(Hash)
    end
  end

  describe '#ship_to' do
    it 'returns a hash' do
      expect(subject.ship_to).to be_kind_of(Hash)
    end
  end

  describe '#default_ship_from' do
    it 'returns a hash' do
      expect(subject.ship_to).to be_kind_of(Hash)
    end
  end
end
