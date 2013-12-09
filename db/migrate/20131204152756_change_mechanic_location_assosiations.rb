class ChangeMechanicLocationAssosiations < ActiveRecord::Migration
  def up
    add_column :mechanics, :location_id, :integer
    add_column :mechanics, :business_location_id, :integer
    add_index :mechanics, :location_id
    add_index :mechanics, :business_location_id

    remove_column :locations, :locatable_id
    remove_column :locations, :locatable_type
    remove_column :locations, :location_type
  end

  def down
    add_column :locations, :locatable_id, :integer
    add_column :locatable_type, :string
    add_column :location_type, :string

    remove_column :mechanics, :location_id
    remove_column :mechanics, :business_location_id
  end
end
