class UpdateSymptoms < ActiveRecord::Migration
  def up
    Symptom.delete_all
    remove_column :symptoms, :ancestry
    add_column :symptoms, :comment, :text
  end

  def down
    add_column :symptoms, :ancestry, :string
    remove_column :symptoms, :comment
  end
end
