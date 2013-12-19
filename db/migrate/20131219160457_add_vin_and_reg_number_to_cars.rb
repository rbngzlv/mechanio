class AddVinAndRegNumberToCars < ActiveRecord::Migration
  def change
    add_column :cars, :vin, :string
    add_column :cars, :reg_number, :string
  end
end
