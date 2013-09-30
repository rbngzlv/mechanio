class AddBusinessDetailsToMechanic < ActiveRecord::Migration
  def change
    add_column :mechanics, :abn_name, :string
    add_column :mechanics, :business_website, :string
    add_column :mechanics, :business_email, :string
    add_column :mechanics, :years_as_a_mechanic, :integer
    add_column :mechanics, :mobile_number, :string
    add_column :mechanics, :other_number, :string
    add_column :mechanics, :abn_number, :string
    add_column :mechanics, :abn_expiry, :date
    add_column :mechanics, :mechanic_license_number, :string
    add_column :mechanics, :mechanic_license_expiry, :date
    add_column :mechanics, :mechanic_license_state_id, :string
  end
end
