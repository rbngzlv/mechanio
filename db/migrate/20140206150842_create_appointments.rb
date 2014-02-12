class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :user_id
      t.integer :mechanic_id
      t.integer :job_id
      t.datetime :scheduled_at
      t.string :status
    end

    add_index :appointments, :user_id
    add_index :appointments, :mechanic_id
    add_index :appointments, :job_id
  end
end
