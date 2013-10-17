class FixDateColumnName < ActiveRecord::Migration
  def change
    rename_column :jobs, :date, :scheduled_at
  end
end
