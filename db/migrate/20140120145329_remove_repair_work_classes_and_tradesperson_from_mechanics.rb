class RemoveRepairWorkClassesAndTradespersonFromMechanics < ActiveRecord::Migration
  def change
    remove_column :mechanics, :repair_work_classes
    remove_column :mechanics, :tradesperson_certificates
  end
end
