class AddStatusToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :status, :string
  end
end
