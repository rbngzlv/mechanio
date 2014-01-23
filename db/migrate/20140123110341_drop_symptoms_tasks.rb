class DropSymptomsTasks < ActiveRecord::Migration
  def change
    drop_table :symptoms_tasks
  end
end
