class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :user_id
      t.integer :car_id
      t.integer :location_id
      t.integer :mechanic_id
      t.string :contact_email
      t.string :contact_phone
      t.decimal :cost, precision: 8, scale: 2
      t.decimal :tax, precision: 8, scale: 2
      t.decimal :total, precision: 8, scale: 2
      t.text :serialized_params

      t.timestamps
    end
  end
end
