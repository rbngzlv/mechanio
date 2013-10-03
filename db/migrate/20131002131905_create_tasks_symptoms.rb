class CreateTasksSymptoms < ActiveRecord::Migration
  def change
    create_join_table :tasks, :symptoms
  end
end
