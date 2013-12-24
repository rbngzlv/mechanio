class RemoveSymptomCategories < ActiveRecord::Migration
  def up
    drop_table :symptom_categories
  end

  def down
  end
end
