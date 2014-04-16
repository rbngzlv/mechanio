class AddRatingToMechanics < ActiveRecord::Migration
  def change
    add_column :mechanics, :rating, :decimal, precision: 8, scale: 2, default: 0
  end
end
