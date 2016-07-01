Spree::ShippingRate.class_eval do
  def tax_rate
    Spree::TaxRate.find(tax_rate_id)
  end
end
