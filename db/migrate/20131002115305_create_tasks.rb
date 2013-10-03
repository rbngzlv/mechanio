class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :type
      t.integer :job_id
      t.integer :service_plan_id
      t.string :note

      t.timestamps
    end
  end
end
