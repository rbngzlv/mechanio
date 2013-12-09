class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
      t.integer :postcode
      t.string :ancestry
      t.integer :state_id
      t.integer :ancestry_depth, default: 0

      t.index :ancestry
      t.index :state_id
    end
  end
end
