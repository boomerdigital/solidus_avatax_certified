# frozen_string_literal: true

FactoryBot.define do
  factory :avalara_order, class: Spree::Order do
    user
    bill_address
    ship_address
    completed_at { nil }
    email { user.email }
    store
    state { 'delivery' }

    transient do
      line_items_attributes { [{}] * line_items_count }
      shipment_attributes { [{}] }
      line_items_price { BigDecimal(10) }
      line_items_count { 1 }
      line_items_quantity { 1 }
      shipment_cost { 5 }
      tax_category { Spree::TaxCategory.first }
      tax_included { false }
      stock_location { create(:stock_location) }
    end

    before(:create) do |_order, evaluator|
      if Spree::Country.count == 0
        create(:country)
      end
      if Spree::Zone.find_by(name: 'GlobalZone').nil?
        create(:global_zone)
      end
      if Spree::TaxCategory.first.nil?
        create(:clothing_tax_rate, tax_categories: [create(:tax_category)], included_in_price: evaluator.tax_included)
      else
        create(:clothing_tax_rate, tax_categories: [Spree::TaxCategory.first], included_in_price: evaluator.tax_included)
      end
    end

    after(:build) do |order, evaluator|
      evaluator.stock_location # must evaluate before creating line items

      evaluator.line_items_attributes.each do |attributes|
        attributes = { order: order, price: evaluator.line_items_price, tax_category: evaluator.tax_category }.merge(attributes)
        create(:line_item, attributes)
      end
      order.line_items.reload

      evaluator.shipment_attributes.each do |attributes|
        attributes = { order: order, cost: evaluator.shipment_cost, stock_location: evaluator.stock_location, tax_included: evaluator.tax_included }.merge(attributes)
        create(:avalara_shipment, attributes)
      end
      order.shipments.reload

      Spree::OrderUpdater.new(order).send(:update_totals)
    end

    after(:create) do |order, evaluator|
      order.next
    end

    factory :completed_avalara_order do
      state { 'complete' }
      payment_state { 'paid' }
      shipment_state { 'ready' }

      after(:create) do |order|
        order.update_column(:completed_at, Time.current)

        order.recalculate

        payment = create(:credit_card_payment, amount: order.total, order: order)
        payment.purchase!

        order.reload
      end
    end
  end
end
