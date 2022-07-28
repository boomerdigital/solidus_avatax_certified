//= require spree/backend/use_code_picker
//= require spree/address_validator

if (typeof Spree.avataxRoutes === 'undefined') {
  Spree.avataxRoutes = {}
}

Spree.avataxRoutes.use_code_search = Spree.pathFor("admin/avalara_entity_use_codes")
Spree.avataxRoutes.validate_address = Spree.pathFor("admin/avatax_settings/validate_address")
