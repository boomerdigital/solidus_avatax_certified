//= require spree/address_validator
//= require spree/frontend/flash

if (typeof Spree.avataxRoutes === 'undefined') {
  Spree.avataxRoutes = {}
}

Spree.avataxRoutes.validate_address = Spree.pathFor("checkout/validate_address")
