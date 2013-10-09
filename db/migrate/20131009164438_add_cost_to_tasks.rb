class AddCostToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :cost, :decimal, precision: 8, scale: 2
    add_column :tasks, :tax, :decimal, precision: 8, scale: 2
    add_column :tasks, :total, :decimal, precision: 8, scale: 2
  end
end
