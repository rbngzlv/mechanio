class AddIndexOnDisplayNameToRegions < ActiveRecord::Migration
  def change
    add_index :regions, :display_name
  end
end
