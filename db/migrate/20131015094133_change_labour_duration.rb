class ChangeLabourDuration < ActiveRecord::Migration
  def change
    rename_column :labours, :duration, :duration_hours
    add_column :labours, :duration_minutes, :integer
  end
end
