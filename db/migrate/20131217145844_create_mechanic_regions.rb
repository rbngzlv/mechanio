class CreateMechanicRegions < ActiveRecord::Migration
  def change
    create_table :mechanic_regions do |t|
      t.integer :mechanic_id
      t.integer :region_id
      t.string :postcode

      t.timestamps
    end
    add_index :mechanic_regions, :mechanic_id
    add_index :mechanic_regions, :region_id
    add_index :mechanic_regions, :mechanic_id, :postcode
  end
end
