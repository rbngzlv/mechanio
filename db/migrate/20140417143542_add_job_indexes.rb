class AddJobIndexes < ActiveRecord::Migration
  def change
    add_index :jobs, :user_id
    add_index :jobs, :mechanic_id
    add_index :jobs, :discount_id
  end
end
