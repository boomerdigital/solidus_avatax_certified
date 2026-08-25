# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusAvataxCertified::Request::GetTax, :vcr do
  subject { described_class.new(order, commit: false, doc_type: 'SalesOrder') }

  let!(:order) { create(:avalara_order, line_items_count: 2) }

  describe '#generate' do
    it 'creates a hash' do
      expect(subject.generate).to be_kind_of Hash
    end

    it 'Commit has value of false' do
      expect(subject.generate[:createTransactionModel][:commit]).to be false
    end

    it 'has ReferenceCode from base_tax_hash' do
      expect(subject.generate[:createTransactionModel][:referenceCode]).to eq(order.number)
    end

    context 'point of order origin (bill-to address)' do
      it 'sends the order bill address as addresses[:pointOfOrderOrigin] at the header level' do
        result = subject.generate[:createTransactionModel]
        expect(result[:addresses][:pointOfOrderOrigin]).to eq(order.bill_address.to_avatax_hash)
      end
    end

    context 'header-level destination and origin addresses' do
      it 'sends the order ship address as addresses[:shipTo]' do
        result = subject.generate[:createTransactionModel]
        expect(result[:addresses][:shipTo]).to eq(order.ship_address.to_avatax_hash)
      end

      it 'sends the configured store origin as addresses[:shipFrom]' do
        result = subject.generate[:createTransactionModel]
        origin = JSON.parse(Spree::Avatax::Config.origin)
        expect(result[:addresses][:shipFrom]).to eq(
          line1: origin['line1'],
          line2: origin['line2'],
          city: origin['city'],
          region: origin['region'],
          country: origin['country'],
          postalCode: origin['postalCode']
        )
      end
    end

    context 'when order has a manual (order-level) discount adjustment' do
      before do
        Spree::Adjustment.create!(
          order: order,
          adjustable: order,
          amount: -5.0,
          label: 'Coupon Code',
          eligible: true
        )
        order.reload
      end

      it 'does not include a header-level discount field' do
        result = subject.generate[:createTransactionModel]
        expect(result).not_to have_key(:discount)
      end

      it 'nets the discount into the item lines instead of a separate line item' do
        lines = subject.generate[:createTransactionModel][:lines]
        expect(lines.any? { |l| l[:number].to_s.include?('ADJ') }).to be false

        item_lines = lines.select { |l| l[:number].to_s.end_with?('-LI') }
        # $5 distributed across two equal $10 lines => $7.50 net per line
        expect(item_lines.map { |l| l[:amount] }).to all(eq(7.5))
      end
    end
  end
end
