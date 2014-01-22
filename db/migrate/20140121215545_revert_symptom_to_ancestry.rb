class RevertSymptomToAncestry < ActiveRecord::Migration
  def up
    Symptom.delete_all
    add_column :symptoms, :ancestry, :string
  end

  def down
    remove_column :symptoms, :ancestry, :string
  end
end
