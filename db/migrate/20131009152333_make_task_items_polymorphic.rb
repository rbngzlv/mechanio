class MakeTaskItemsPolymorphic < ActiveRecord::Migration
  def up
    remove_column :parts, :task_id
    remove_column :labours, :task_id
    remove_column :fixed_amounts, :task_id
  end

  def down
    add_column :parts, :task_id, :integer
    add_column :labours, :task_id, :integer
    add_column :fixed_amounts, :task_id, :integer
  end
end
