Spree.ready(function(){
  validator = new AddressValidator();
  validator.bindListeners();
});

function AddressValidator(){
  this.lineHash = {
    address1: "Line1",
    address2: "Line2",
    city: "City",
    zipcode: "PostalCode",
    country: "Country",
    state: "Region"
  };
}

AddressValidator.prototype = {
  bindListeners: function(){
    $(".address_validator").on("click", this.validate.bind(this));
  },
  validate: function(){
    event.preventDefault();
    $("#checkout_form_address").validate().form();
    var address = this.formatAddress();

    $.ajax({
      url: Spree.routes.validate_address,
      data: {
        address: address,
        state: "address"
      }
    }).done(function(data){
      var controller = this;
      var wrapper = controller.addressWrapper();

      if (data['ResultCode'] === 'Error') {
        return this.showFlash(data);
      }

      $.each(["Line1", "Line2", "City", "PostalCode"], function(index, value){
        var keyVal = controller.getKeyByValue(value);
        $(wrapper + " input[id*='" + keyVal + "']").val(data.Address[value]);
      }.bind(address));

      this.showFlash(data);
    }.bind(this));
  },
  formatAddress: function() {
    var address = {};
    controller = this;
    var wrapper = controller.addressWrapper();

    $(wrapper + " input").not("select").each(function(){
      var id = $(this).attr("id");
      var line = controller.lineHash[id.split("_").pop()];
      address[line] = $(this).val();
    });

    $(wrapper + " select").each(function(){
      var id = $(this).attr("id");
      var line = controller.lineHash[id.slice(0, -3).split("_").pop()];
      address[line] = $(this).val();
    });

    return address;
  },
  getKeyByValue: function(value) {
    return Object.keys(this.lineHash).find(function(key){ return this[key] === value}.bind(this.lineHash));
  },
  showFlash: function(data){
    var resultCode = data.ResultCode.toLowerCase();

    if(resultCode === "success") {
      window.show_flash("success", "Address Validation Successful");
    } else {
      details = $(data['Messages']).map(function(){return this['Summary']}).get().join(' ');
      window.show_flash("error", "Address Validation Error: " + details);
    }
  },
  addressWrapper: function(){
    if($("#order_use_billing").is(":checked")){
      return "#billing";
    } else {
      return "#shipping";
    }
  }
}
