
Deface::Override.new(
  virtual_path: 'spree/checkout/_address',
  name:         'add validator button to address',
  insert_before:   '[data-hook="buttons"]',
  text: "<% if Spree::AvalaraPreference.customer_can_validate.is_true? %><button class='button address_validator'>Validate Ship Address</button><% end %>"
)
