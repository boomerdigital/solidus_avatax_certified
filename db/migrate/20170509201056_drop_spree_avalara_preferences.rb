class DropSpreeAvalaraPreferences < ActiveRecord::Migration
  def change
    drop_table :spree_avalara_preferences
    p '****** Remember to reenter your avatax preferences! ******'
  end
end
