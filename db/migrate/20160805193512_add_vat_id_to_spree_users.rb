# frozen_string_literal: true

class AddVatIdToSpreeUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_users, :vat_id, :string
  end
end
