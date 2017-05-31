Spree.ready(function(){
  validator = new AddressValidator();
  validator.bindListeners();
});

function AddressValidator(){
  this.lineHash = {
    address1: "line1",
    address2: "line2",
    city: "city",
    zipcode: "postalCode",
    country: "country",
    state: "region"
  };
}

AddressValidator.prototype = {
  bindListeners: function(){
    $(".address_validator").on("click", this.validate.bind(this));
  },
  validate: function(e){
    e.preventDefault();
    var address = this.formatAddress();

    $.ajax({
      url: Spree.routes.validate_address,
      data: {
        address: address
      }
    }).done(function(data){
      var controller = this;
      var wrapper = controller.addressWrapper();

      if (data.responseCode === 'error') {
        return this.showFlash(data);
      }

      var validatedAddress = data.validatedAddresses[0];

      $.each(["line1", "line2", "city", "postalCode"], function(index, value){
        var keyVal = controller.getKeyByValue(value);
        $(wrapper + " input[id*='" + keyVal + "']").val(validatedAddress[value]);
      }.bind(address));

      this.showFlash(data);
    }.bind(this));
  },
  formatAddress: function() {
    var address = {};
    controller = this;
    var wrapper = controller.addressWrapper();

    $(wrapper + " input").not("[name$='name]']").not("[class*=select2]").each(function(){
      var id = $(this).attr("id");
      var line = controller.lineHash[id.split("_").pop()];
      address[line] = $(this).val();
    });

    $(wrapper + " select.select2").each(function(){
      var line = controller.lineHash[$(this).attr("id")];
      address[line] = $(this).select2("val");
    });

    return address;
  },
  getKeyByValue: function(value) {
    return Object.keys(this.lineHash).find(function(key){ return this[key] === value}.bind(this.lineHash));
  },
  showFlash: function(data){
    if(data.responseCode === 'error') {
      var details = data.errorMessages.join(', ');
      window.show_flash("error", "Address Validation Error: " + details);
    } else {
      window.show_flash("success", "Address Validation Successful");
    }
  },
  addressWrapper: function(){
    if($("#shipping").length != 0){
      return "#shipping";
    } else {
      return "#business-address";
    }
  }
}
