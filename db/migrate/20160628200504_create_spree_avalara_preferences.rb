class CreateSpreeAvalaraPreferences < ActiveRecord::Migration
  def change
    create_table :spree_avalara_preferences do |t|
      t.string :name, null: false
      t.string :value
      t.string :object_type, null: false
      t.timestamps null: false
    end
  end
end
