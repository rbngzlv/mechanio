class CreateSymptomsHierarchies < ActiveRecord::Migration
  def change
    create_table :symptom_hierarchies do |t|
      t.integer :symptom_id
      t.integer :child_id
    end

    add_index :symptom_hierarchies, [:symptom_id, :child_id], unique: true
    add_index :symptom_hierarchies, :child_id
  end
end
