class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :user_id
      t.integer :car_id
      t.integer :service_plan_id
      t.decimal :quote
      t.string :contact_email
      t.string :contact_phone

      t.timestamps
    end
  end
end
