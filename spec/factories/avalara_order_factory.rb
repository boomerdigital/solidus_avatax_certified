FactoryGirl.define do
  factory :avalara_order, class: Spree::Order do
    user
    bill_address
    ship_address
    completed_at nil
    email { user.email }
    store
    state 'delivery'

    transient do
      line_items_price BigDecimal.new(10)
      line_items_count 1
      line_items_quantity 1
      shipment_cost 5
      tax_category Spree::TaxCategory.first
    end

    before(:create) do |order, evaluator|
      if Spree::Country.count == 0
        create(:country)
      end
      if Spree::Zone.find_by(name: 'GlobalZone').nil?
        create(:global_zone, default_tax: true)
      end
      if Spree::TaxCategory.first.nil?
        create(:clothing_tax_rate, tax_category: create(:tax_category))
      else
        create(:clothing_tax_rate, tax_category: Spree::TaxCategory.first)
      end
    end

    after(:create) do |order, evaluator|
      create_list(:line_item, evaluator.line_items_count, order: order, price: evaluator.line_items_price, tax_category: evaluator.tax_category, quantity: evaluator.line_items_quantity)
      order.line_items.reload

      create(:avalara_shipment, order: order, cost: evaluator.shipment_cost )
      order.shipments.reload

      order.update!
      order.next
    end

    factory :completed_avalara_order do
      state 'complete'

      after(:create) do |order|
        # order.refresh_shipment_rates
        order.update_column(:completed_at, Time.now)
      end
    end
  end
end
