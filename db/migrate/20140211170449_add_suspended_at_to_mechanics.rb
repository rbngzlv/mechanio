class AddSuspendedAtToMechanics < ActiveRecord::Migration
  def change
    add_column :mechanics, :suspended_at, :datetime
  end
end
