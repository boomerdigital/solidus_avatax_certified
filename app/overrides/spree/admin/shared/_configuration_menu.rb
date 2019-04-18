# frozen_string_literal: true

Deface::Override.new(
  virtual_path: 'spree/admin/shared/_taxes_tabs',
  name: 'add_avalara_admin_menu_links',
  insert_bottom: "[data-hook='admin_settings_taxes_tabs']"
) do
  <<-HTML
    <%= configurations_sidebar_menu_item t('spree.avalara_settings'), admin_avatax_settings_path %>
    <%= configurations_sidebar_menu_item t('spree.avalara_entity_use_codes'), admin_avalara_entity_use_codes_path %>
  HTML
end
