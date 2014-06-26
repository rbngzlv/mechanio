class RemoveCreatedAtFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :created_at
    remove_column :events, :updated_at
  end
end
