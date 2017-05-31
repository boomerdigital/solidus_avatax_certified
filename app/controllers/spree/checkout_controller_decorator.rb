Spree::CheckoutController.class_eval do
  def validate_address
    mytax = TaxSvc.new
    address = permitted_address_validation_attrs

    address['country'] = Spree::Country.find_by(id: address['country']).try(:iso)
    address['region'] = Spree::State.find_by(id: address['region']).try(:abbr)

    response = mytax.validate_address(address)
    result = response.result

    if response.failed?
      result.merge!({ 'responseCode': 'error', 'errorMessages': response.summary_messages })
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end


  private

  def permitted_address_validation_attrs
    params['address'].permit(:line1, :line2, :city, :postalCode, :country, :region).to_h
  end
end
