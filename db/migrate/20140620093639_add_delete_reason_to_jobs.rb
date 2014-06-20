class AddDeleteReasonToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :delete_reason, :string
    add_column :jobs, :delete_reason_other, :string
    add_column :jobs, :estimate_deleted_at, :datetime
  end
end
