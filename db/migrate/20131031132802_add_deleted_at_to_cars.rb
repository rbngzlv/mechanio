class AddDeletedAtToCars < ActiveRecord::Migration
  def change
    add_column :cars, :deleted_at, :datetime
  end
end
