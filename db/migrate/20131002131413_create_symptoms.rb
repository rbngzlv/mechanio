class CreateSymptoms < ActiveRecord::Migration
  def change
    create_table :symptoms do |t|
      t.integer :symptom_category_id
      t.string :description

      t.timestamps
    end
  end
end
