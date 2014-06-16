class AddRegionToLocation < ActiveRecord::Migration
  def change
    change_table :locations do |t|
      t.column :suburb_id, :integer
      t.index :suburb_id
    end
    remove_column :locations, :suburb, :string
  end
end
