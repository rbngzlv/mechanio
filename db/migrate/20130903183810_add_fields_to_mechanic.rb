class AddFieldsToMechanic < ActiveRecord::Migration
  def change
    change_table :mechanics do |t|
      t.date      :dob
      t.text      :description
      t.text      :street_address
      t.string    :suburb
      t.integer   :state_id
      t.string    :postcode
      t.string    :driver_license
      t.integer   :license_state_id
      t.date      :license_expiry
    end
  end
end
