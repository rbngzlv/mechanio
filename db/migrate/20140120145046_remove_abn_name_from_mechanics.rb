class RemoveAbnNameFromMechanics < ActiveRecord::Migration
  def change
    remove_column :mechanics, :abn_name
  end
end
