class AddDiscountToJobs < ActiveRecord::Migration
  def up
    add_column :jobs, :discount_id, :integer
    add_column :jobs, :discount_amount, :decimal, precision: 8, scale: 2
    add_column :jobs, :final_cost, :decimal, precision: 8, scale: 2

    Job.update_all('final_cost = cost')
  end

  def down
    remove_column :jobs, :final_cost
    remove_column :jobs, :discount_amount
    remove_column :jobs, :discount_id
  end
end
