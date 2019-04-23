# frozen_string_literal: true

Deface::Override.new(
  virtual_path: 'spree/admin/users/_addresses_form',
  name: 'add validator button',
  insert_bottom: '[data-hook="ship_address_wrapper"]',
  text: "<a href='#'' class='button address_validator' style='float: right;'>Validate Ship Address</a>"
)
