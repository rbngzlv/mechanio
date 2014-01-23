class DropSymptomHierarchies < ActiveRecord::Migration
  def up
    drop_table :symptom_hierarchies
  end

  def down; end
end
