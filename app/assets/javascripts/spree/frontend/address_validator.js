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
      var address = data.Address;
      var controller = this;
      var wrapper = controller.addressWrapper();

      $.each(["Line1", "Line2", "City", "PostalCode"], function(index, value){
        var keyVal = controller.getKeyByValue(value);
        $(wrapper + " input[id*='" + keyVal + "']").val(address[value]);
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
    return Object.keys(this.lineHash).find(key => this.lineHash[key] === value);
  },
  showFlash: function(data){
    var resultCode = data.ResultCode.toLowerCase();

    if(resultCode === "success") {
      window.show_flash("success", "Address Validation Successful");
    } else {
      window.show_flash("error", "Address Validation Error: " + data.Summary);
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