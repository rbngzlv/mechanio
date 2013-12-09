class AddJobIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :job_id, :integer
  end
end
