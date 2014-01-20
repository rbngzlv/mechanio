class AddFieldsToMechanics < ActiveRecord::Migration
  def change
    add_column :mechanics, :repair_work_classes, :text
    add_column :mechanics, :tradesperson_certificates, :text
  end
end
