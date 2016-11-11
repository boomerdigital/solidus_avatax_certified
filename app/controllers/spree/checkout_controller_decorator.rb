Spree::CheckoutController.class_eval do
  def validate_address
    mytax = TaxSvc.new
    address = permitted_address_validation_attrs

    address['Country'] = Spree::Country.find_by(id: address['Country']).try(:iso)
    address['Region'] = Spree::State.find_by(id: address['Region']).try(:abbr)

    response = mytax.validate_address(address)

    respond_to do |format|
      format.json { render json: response }
    end
  end


  private

  def permitted_address_validation_attrs
    params['address'].permit(:Line1, :Line2, :City, :PostalCode, :Country, :Region).to_h
  end
end
