class AddAssignedAtToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :assigned_at, :datetime
  end
end
