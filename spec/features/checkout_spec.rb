# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Checkout', :vcr, :js do
  let(:product) { Spree::Product.first }
  let(:included_in_price) { false }
  let!(:order) { create(:avalara_order, state: 'cart', shipment_cost: 10, tax_included: included_in_price) }
  let!(:user) { order.user }

  before do
    allow_any_instance_of(Spree::CheckoutController).to receive_messages(current_order: order)
    allow_any_instance_of(Spree::CheckoutController).to receive_messages(try_spree_current_user: user)
  end

  context 'address' do
    before do
      visit_address
    end

    it 'has no tax adjustments on page' do
      expect(page).not_to have_content('Tax')
      expect(page).not_to have_content('Shipping Tax')
    end
  end

  context 'payment' do
    before do
      visit_delivery
    end

    context 'tax not included' do
      before do
        click_button 'Save and Continue'
      end

      context 'on payment page' do
        it 'has tax and shipping tax adjustments on page' do
          expect(page).to have_content('Tax')
          expect(page).to have_content('Shipping Tax')
          expect(page).to have_content('$0.40', count: 2)
        end

        it 'order line_items and shipments and shipments have an additional_tax_total sum of 0.40' do
          expect(order.line_items.sum(:additional_tax_total).to_f).to eq(0.40)
          expect(order.shipments.sum(:additional_tax_total).to_f).to eq(0.40)
          expect(order.all_adjustments.tax.count).to eq(2)
        end
      end
    end

    context 'tax included' do
      let(:included_in_price) { true }

      before do
        Spree::TaxRate.update_all(included_in_price: true)
        order.reload
        click_button 'Save and Continue'
      end

      it 'has tax and shipping tax adjustments on page' do
        expect(page).to have_content('Tax (Included in Price)')
        expect(page).to have_content('Shipping Tax (Included in Price)')
        expect(page).to have_content('$0.38', count: 2)
      end

      it 'order line_items and shipments have an included_tax_total sum of 0.38' do
        expect(order.line_items.sum(:included_tax_total).to_f).to eq(0.38)
        expect(order.shipments.sum(:included_tax_total).to_f).to eq(0.38)
        expect(order.all_adjustments.tax.count).to eq(2)
      end
    end

    context 'with promotion' do
      context 'tax not included' do
        let(:promotion) { create(:promotion, :with_line_item_adjustment, adjustment_rate: 5) }

        before do
          order.line_items.each do |li|
            create(:adjustment, order: order, source: promotion.promotion_actions.first, adjustable: li)
          end
          order.updater.update
          order.reload
          click_button 'Save and Continue'
        end

        it 'has adjusted tax amount after promotion applied' do
          expect(page).to have_content('-$5.00')
          expect(order.line_items.sum(:additional_tax_total).to_f).to eq(0.2)
          expect(page).to have_content('$0.2')
        end
      end
    end
  end

  context 'complete order' do
    let!(:payment_method) { create(:check_payment_method) }

    before do
      allow(order).to receive_messages(available_payment_methods: [payment_method])
      visit_delivery
      click_button 'Save and Continue'
      click_button 'Save and Continue'
      click_button 'Place Order'
    end

    it 'has tax and shipping tax adjustments on page' do
      expect(page).to have_content('Tax')
      expect(page).to have_content('Shipping Tax')
      expect(page).to have_content('$0.40', count: 2)
    end

    it 'order line_items and shipments have an additional_tax_total sum of 0.40' do
      expect(order.line_items.sum(:additional_tax_total).to_f).to eq(0.40)
      expect(order.shipments.sum(:additional_tax_total).to_f).to eq(0.40)
      expect(order.all_adjustments.tax.count).to eq(2)
    end
  end

  def visit_address
    order.all_adjustments.destroy_all
    order.line_items.update_all(additional_tax_total: 0.0)
    order.shipments.update_all(additional_tax_total: 0.0)
    visit spree.checkout_state_path(:address)
  end

  def visit_delivery
    visit_address
    click_button 'Save and Continue'
  end
end
