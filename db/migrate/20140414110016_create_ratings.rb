class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :mechanic_id
      t.integer :job_id
      t.integer :professional
      t.integer :service_quality
      t.integer :communication
      t.integer :parts_quality
      t.integer :convenience
      t.text :comment
      t.boolean :recommend

      t.timestamps

      t.index :user_id
      t.index :mechanic_id
      t.index :job_id
    end
  end
end
