Spree::CheckoutController.class_eval do
  def validate_address
    mytax = TaxSvc.new
    address = params['address']

    if address['Country'].to_i != 0
      address['Country'] = Spree::Country.find(address['Country']).try(:iso)
    end

    if address['Region'].to_i != 0
      address['Region'] = Spree::State.find(address['Region']).try(:abbr)
    end

    response = mytax.validate_address(address)

    respond_to do |format|
      format.json { render json: response }
    end
  end
end
