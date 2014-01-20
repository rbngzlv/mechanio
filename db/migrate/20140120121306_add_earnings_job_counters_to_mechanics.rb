class AddEarningsJobCountersToMechanics < ActiveRecord::Migration
  def change
    add_column :mechanics, :total_earnings, :decimal, precision: 8, scale: 2, default: 0
    add_column :mechanics, :current_jobs_count, :integer, default: 0
    add_column :mechanics, :completed_jobs_count, :integer, default: 0
  end
end
