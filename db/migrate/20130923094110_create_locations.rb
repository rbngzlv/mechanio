class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address
      t.string :suburb
      t.string :postcode
      t.integer :state_id
      t.references :locatable, polymorphic: true

      t.timestamps
    end
  end
end
