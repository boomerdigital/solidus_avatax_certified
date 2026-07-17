//= require spree/address_validator
//= require spree/frontend/flash

document.addEventListener('DOMContentLoaded', function() {
  var validatePath = 'checkout/validate_address';
  if (typeof Solidus !== 'undefined' && Solidus.routes) {
    Solidus.routes.validate_address = Solidus.pathFor(validatePath);
  }
  if (typeof Spree !== 'undefined' && Spree.routes) {
    Spree.routes.validate_address = Spree.pathFor ? Spree.pathFor(validatePath) : '/' + validatePath;
  }
});
