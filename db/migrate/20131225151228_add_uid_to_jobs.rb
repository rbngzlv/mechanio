class AddUidToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :uid, :string
  end
end
