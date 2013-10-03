class CreateSymptomCategories < ActiveRecord::Migration
  def change
    create_table :symptom_categories do |t|
      t.string :description

      t.timestamps
    end
  end
end
