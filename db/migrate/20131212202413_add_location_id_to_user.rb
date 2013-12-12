class AddLocationIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :location_id, :integer
    add_index :users, :location_id
  end
end
