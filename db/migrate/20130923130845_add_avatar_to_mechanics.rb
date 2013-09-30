class AddAvatarToMechanics < ActiveRecord::Migration
  def change
    add_column :mechanics, :avatar, :string
    rename_column :mechanics, :driver_license, :driver_license_number
    add_column :mechanics, :driver_license, :string
    add_column :mechanics, :abn, :string
    add_column :mechanics, :mechanic_license, :string
  end
end
