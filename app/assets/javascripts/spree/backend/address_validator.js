$(document).ready(function() {
  validator = new AddressValidator();
  validator.bindListeners();
});

function AddressValidator(){}

AddressValidator.prototype = {
  bindListeners: function(){
    $('.address_validator').on('click', this.validate.bind(this))
  },
  validate: function(){
    event.preventDefault()
    var address = this.format_address()

    // Maybe populate fields with validated address in future
    Spree.ajax({
      url: Spree.routes.validate_address,
      data: {
        address: address
      }
    })
  },
  format_address: function() {
    var address = {}
    $('#business-address .avatax').not('.select2').each(function(){
      var id = $(this).attr('id');
      var line = id.substring(id.indexOf("_") + 1)
      address[line] = $(this).val()
    })

    address['Country'] = parseInt($('#scountry .select2.avatax').select2('val'))
    address['Region'] = parseInt($('#sstate .select2.avatax').select2('val'))
    return address;
  }
}
