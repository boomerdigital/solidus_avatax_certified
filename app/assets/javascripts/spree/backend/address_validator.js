$(document).ready(function() {
  validator = new AddressValidator();
  validator.bindListeners();
});

function AddressValidator(){
  this.lineHash = {
    address1: 'Line1',
    address2: 'Line2',
    city: 'City',
    zipcode: 'PostalCode',
    country: 'Country',
    state: 'Region'
  }
}

AddressValidator.prototype = {
  bindListeners: function(){
    $('.address_validator').on('click', this.validate.bind(this))
  },
  validate: function(){
    event.preventDefault()
    var address = this.formatAddress()

    $.ajax({
      url: Spree.routes.validate_address,
      data: {
        address: address
      }
    }).done(function(data){
      var address = data.Address;
      var controller = this;
      $.each(['Line1', 'Line2', 'City', 'PostalCode'], function(index, value){
        var keyVal = controller.getKeyByValue(value);
        $("#shipping input[id*='" + keyVal + "']").val(address[value])
      }.bind(address))

      this.showFlash(data)
    }.bind(this))
  },
  formatAddress: function() {
    var address = {}
    controller = this;
    var wrapper = controller.addressWrapper();

    $(wrapper + ' input').not("[name$='name]']").not("[class*=select2]").each(function(){
      var id = $(this).attr('id');
      var line = controller.lineHash[id.split('_').pop()]
      address[line] = $(this).val()
    })

    $(wrapper + " select.select2").each(function(){
      var line = controller.lineHash[$(this).attr('id')]
      address[line] = $(this).select2('val')
    })

    return address;
  },
  getKeyByValue: function(value) {
    return Object.keys(this.lineHash).find(key => this.lineHash[key] === value);
  },
  showFlash: function(data){
    var resultCode = data.ResultCode.toLowerCase()

    if(resultCode === 'success') {
      window.show_flash('success', "Address Validation Successful")

    } else {
      window.show_flash('error', "Address Validation Error: " + data.Summary)
    }
  },
  addressWrapper: function(){
    if($('#shipping').length != 0){
      return '#shipping';
    } else {
      return '#business-address';
    }
  }
}
