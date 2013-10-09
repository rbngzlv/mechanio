class CreateTaskItems < ActiveRecord::Migration
  def change
    create_table :task_items do |t|
      t.integer :task_id
      t.references :itemable, polymorphic: true
    end
  end
end
