class AddAncestryToSymptoms < ActiveRecord::Migration
  def change
    add_column :symptoms, :ancestry, :string
    add_index :symptoms, :ancestry

    remove_column :symptoms, :parent_id
  end
end
