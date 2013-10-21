class AddUnitCostToParts < ActiveRecord::Migration
  def change
    add_column :parts, :unit_cost, :decimal, precision: 8, scale: 2, after: :name
  end
end
