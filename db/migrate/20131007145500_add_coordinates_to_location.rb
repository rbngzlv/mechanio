class AddCoordinatesToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :latitude, :decimal, precision: 12, scale: 8
    add_column :locations, :longitude, :decimal, precision: 12, scale: 8
  end
end
