class AddUidToJobs < ActiveRecord::Migration
  def up
    add_column :jobs, :uid, :string
    Job.all.each do |j|
      j.set_uid
      j.save(validate: false)
    end
  end

  def down
    remove_column :jobs, :uid
  end
end
