class RevertSymptomToAncestry < ActiveRecord::Migration
  def up
    Symptom.delete_all
    add_column :symptoms, :ancestry, :string
    remove_column :symptoms, :comment
    change_column :symptoms, :description, :text
  end

  def down
    remove_column :symptoms, :ancestry, :string
    add_column :symptoms, :comment, :text
    change_column :symptoms, :description, :string
  end
end
