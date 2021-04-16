# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Calculator::AvalaraTransaction do
  describe '#description' do
    it 'responds with avalara_transaction' do
      expect(described_class.new.description).to eq('Avalara Transaction Calculator')
    end
  end

  describe '#compute_line_item', :vcr do
    let(:included_in_price) { false }
    let(:tax_category) { Spree::TaxCategory.find_or_create_by(name: 'Clothing', tax_code: 'P0000000') }
    let(:calculator) { Spree::TaxRate.find_by(name: 'Tax').calculator }
    let!(:order) { create(:avalara_order, line_items_price: 10, shipment_cost: 100, tax_included: included_in_price, line_items_attributes: [{id: 1}]) }
    let(:line_item) { order.line_items.first }

    context 'when given an order' do
      before do
        allow(order).to receive_messages line_items: [line_item]
      end

      it 'raises error' do
        expect{ calculator.compute(order) }.to raise_error(RuntimeError)
      end
    end

    context 'when tax is included in price' do
      let(:included_in_price) { true }

      it 'is equal to the item pre-tax total * rate' do
        expect(calculator.compute(line_item)).to eq(0.38)
      end

      it 'is equal to the previous included_tax_total is order is at cart' do
        order.state = 'cart'
        line_item.included_tax_total = 0.1
        expect(calculator.compute(line_item)).to eq(0.1)
      end

      it 'is equal to the previous included_tax_total is order is at address' do
        order.state = 'address'
        line_item.included_tax_total = 0.1
        expect(calculator.compute(line_item)).to eq(0.1)
      end
    end

    context 'when tax is not included in price' do
      it 'is equal to the item pre-tax total * rate' do
        expect(calculator.compute(line_item)).to eq(0.4)
      end

      it 'is equal to the previous additional_tax_total if order is at cart' do
        order.state = 'cart'
        line_item.additional_tax_total = 0.1
        expect(calculator.compute(line_item)).to eq(0.1)
      end

      it 'is equal to the previous additional_tax_total if order is at address' do
        order.state = 'address'
        line_item.additional_tax_total = 0.1
        expect(calculator.compute(line_item)).to eq(0.1)
      end

      it 'is equal to the previous tax total if preference tax_calculation is false' do
        Spree::Avatax::Config.tax_calculation = false

        line_item.additional_tax_total = 0.1
        expect(calculator.compute(line_item)).to eq(0.1)
      end

      context 'when the order is discounted' do
        let(:promotion) { create(:promotion, :with_order_adjustment, weighted_order_adjustment_amount: 2) }

        before do
          create(:adjustment, order: order, source: promotion.promotion_actions.first, adjustable: order)
          order.updater.update
        end

        it 'is equal to the items pre-tax total * rate' do
          expect(calculator.compute(line_item)).to eq(0.32)
        end
      end

      context 'when the line item is discounted' do
        let!(:promo_adjustment) { create(:adjustment, adjustable: line_item, order: line_item.order, source: promo_action, amount: -2) }
        let(:promo_action) { promo.actions[0] }
        let(:promo) { create(:promotion, :with_line_item_adjustment, apply_automatically: true, adjustment_rate: 2 ) }

        before do
          line_item.update!(price: 20)
        end

        it 'is equal to the items pre-tax total * rate' do
          expect(calculator.compute(line_item)).to eq(0.72)
        end

        it 'with quantity of 2' do
          line_item.update!(quantity: 2)
          expect(calculator.compute(line_item)).to eq(1.52)
        end
      end
    end
  end

  describe '#compute_shipment', :vcr do
    subject(:calculate_shipment) do
      order.reload
      shipping_calculator.compute(shipment)
    end

    let(:included_in_price) { false }
    let(:tax_category) { Spree::TaxCategory.find_or_create_by(name: 'Clothing', tax_code: 'P0000000') }
    let(:calculator) { Spree::TaxRate.find_by(name: 'Tax').calculator }
    let!(:order) { create(:avalara_order, line_items_price: 10, shipment_cost: 100, tax_included: included_in_price, shipment_attributes: [{id: 1}]) }
    let(:shipping_rate) { Spree::TaxRate.find_by(name: 'Shipping Tax') }
    let(:shipping_calculator) { described_class.new(calculable: shipping_rate) }
    let(:shipment) { order.shipments.first }

    it 'is equal 4.0' do
      expect(calculate_shipment).to eq(4.0)
    end

    context 'with promotion' do
      let!(:promo_adjustment) { create(:adjustment, adjustable: shipment, order: order, source: promo_action, amount: -1) }
      let(:promo_action) { promo.actions[0] }
      let(:promo) { create(:promotion, :with_line_item_adjustment, adjustment_rate: 1) }

      it 'equals 3.92' do
        order.recalculate
        expect(calculate_shipment).to eq(3.92)
      end
    end

    context 'when tax is included in price' do
      let(:included_in_price) { true }

      it 'is equal to 3.85' do
        expect(calculate_shipment).to eq(3.85)
      end
    end
  end
end
