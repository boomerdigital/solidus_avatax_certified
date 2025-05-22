var AddressValidator;

Spree.lineHash = {
  address1: 'line1',
  address2: 'line2',
  city: 'city',
  zipcode: 'postalCode',
  country: 'country',
  state: 'region'
};

AddressValidator = class AddressValidator {
  constructor() {
    this.$addressValidator = $('.address_validator');
  }

  validate() {
    var address;
    address = this.formatAddress();
    return Spree.ajax({
      method: 'GET',
      url: Spree.pathFor("admin/avatax_settings/validate_address"),
      data: {
        address: address,
        state: 'address'
      },
      success: (function(data) {
        var validatedAddress, wrapper;
        if (data.responseCode === 'error') {
          return this.showFlash(data);
        }
        validatedAddress = data.validatedAddresses[0];
        wrapper = this.addressWrapper();
        $.each(['address1', 'address2', 'city', 'zipcode'], function(index, value) {
          return $(wrapper + ' input[id*=\'' + value + '\']').val(validatedAddress[Spree.lineHash[value]]);
        });
        return this.showFlash(data);
      }).bind(this)
    });
  }

  formatAddress() {
    var address, wrapper;
    address = {};
    wrapper = this.addressWrapper();
    $(wrapper + ' input').not('select').each(function() {
      var id, line;
      id = $(this).attr('id');
      line = Spree.lineHash[id.split('_').pop()];
      return address[line] = $(this).val();
    });
    $(wrapper + ' select').each(function() {
      var id, line;
      id = $(this).attr('id');
      line = Spree.lineHash[id.slice(0, -3).split('_').pop()];
      return address[line] = $(this).val();
    });
    return address;
  }

  addressWrapper() {
    if ($('#business-address').length !== 0) {
      return '#business-address';
    }
    if ($('#order_use_billing').is(':checked')) {
      return '#billing';
    } else {
      return '#shipping';
    }
  }

  showFlash(data) {
    var details;
    if (data.responseCode === 'error') {
      details = data.errorMessages.join(', ');
      return window.show_flash('error', 'Address Validation Error: ' + details);
    } else {
      return window.show_flash('success', 'Address Validation Successful');
    }
  }

};

Spree.ready(function($) {
  return $('.address_validator').click(function(e) {
    e.preventDefault();
    return new AddressValidator().validate();
  });
});
