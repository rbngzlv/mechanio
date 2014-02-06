class AddReasonForCancelToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :reason_for_cancel, :string
  end
end
