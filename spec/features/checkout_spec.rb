require 'spec_helper'

describe "Checkout", :vcr, type: :feature, inaccessible: true do
  let(:product) { Spree::Product.first }
  let!(:order) { create(:avalara_order, state: 'cart', shipment_cost: 10) }
  let!(:user) { order.user }

  before do
    allow_any_instance_of(Spree::CheckoutController).to receive_messages(:current_order => order)
    allow_any_instance_of(Spree::CheckoutController).to receive_messages(:try_spree_current_user => user)
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

  context 'delivery', js: true do
    before do
      visit_delivery
    end

    it 'has no tax adjustments on page' do
      expect(page).not_to have_content('Tax')
      expect(page).not_to have_content('Shipping Tax')
    end
  end

  context 'payment', js: true do
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
          order.update!
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

  context 'complete order', js: true do
    let(:payment_method) { create(:credit_card_payment_method) }
    let!(:credit_card) do
      create(:credit_card, user_id: order.user.id, payment_method: payment_method, gateway_customer_profile_id: "BGS-WEFWF")
    end
    before do
      allow(order).to receive_messages(:available_payment_methods => [ payment_method ])
      visit_delivery
      click_button 'Save and Continue'
      click_button "Save and Continue"
      click_button "Place Order"
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


  def fill_in_address
    address = "order_bill_address_attributes"
    fill_in "#{address}_firstname", with: "Ryan"
    fill_in "#{address}_lastname", with: "Bigg"
    fill_in "#{address}_address1", with: "915 S Jackson St"
    fill_in "#{address}_city", with: "Montgomery"
    select "United States of America", from: "#{address}_country_id"
    select "Alabama", from: "#{address}_state_id"
    fill_in "#{address}_zipcode", with: "36104"
    fill_in "#{address}_phone", with: "(555) 555-5555"
  end

  def visit_address
    order.all_adjustments.destroy_all
    order.line_items.update_all(additional_tax_total: 0.0)
    order.shipments.update_all(additional_tax_total: 0.0)
    visit spree.checkout_state_path(:address)
  end

  def visit_delivery
    VCR.use_cassette('address_validation_success', allow_playback_repeats: true) do
      visit_address
      fill_in_address
      click_button 'Save and Continue'
    end
  end
end
