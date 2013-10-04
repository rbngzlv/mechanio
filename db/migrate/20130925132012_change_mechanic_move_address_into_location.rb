class ChangeMechanicMoveAddressIntoLocation < ActiveRecord::Migration
  def up
    remove_column :mechanics, :street_address
    remove_column :mechanics, :suburb
    remove_column :mechanics, :state_id
    remove_column :mechanics, :postcode
  end

  def down
    add_column :mechanics, :street_address, :text
    add_column :mechanics, :suburb, :string
    add_column :mechanics, :state_id, :integer
    add_column :mechanics, :postcode, :string
  end
end
