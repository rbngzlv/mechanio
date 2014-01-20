class AddBusinessNameAndMobileNumberToMechanics < ActiveRecord::Migration
  def change
    add_column :mechanics, :business_name, :string
    add_column :mechanics, :business_mobile_number, :string
  end
end
