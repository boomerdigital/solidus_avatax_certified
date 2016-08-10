Spree::CheckoutController.class_eval do
  def validate_address
    mytax = TaxSvc.new
    address = params['address']

    address['Country'] = Spree::Country.find_by(id: address['Country']).try(:iso)
    address['Region'] = Spree::State.find_by(id: address['Region']).try(:abbr)

    response = mytax.validate_address(address)

    respond_to do |format|
      format.json { render json: response }
    end
  end
end
