Spree::ShippingRate.class_eval do
  def tax_rate
    Spree::TaxRate.find(tax_rate_id) if tax_rate_id
  end

  def display_price
    price = display_amount.to_s

    return price if Spree::AvalaraPreference.tax_calculation.is_true?
    return price if taxes.empty? || amount == 0

    tax_explanations = taxes.map(&:label).join(tax_label_separator)

    Spree.t :display_price_with_explanations,
             scope: 'shipping_rate.display_price',
             price: price,
             explanations: tax_explanations
  end
  alias_method :display_cost, :display_price
end
