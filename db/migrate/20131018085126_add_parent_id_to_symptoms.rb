class AddParentIdToSymptoms < ActiveRecord::Migration
  def change
    rename_column :symptoms, :symptom_category_id, :parent_id
  end
end
