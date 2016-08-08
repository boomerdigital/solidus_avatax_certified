
Deface::Override.new(
  virtual_path: 'spree/checkout/_address',
  name:         'add validator button to address',
  insert_before:   '[data-hook="buttons"]',
  text: "<a href='#' class='button address_validator'>Validate Ship Address</a>"
)
