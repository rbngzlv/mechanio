class CreateModelVariations < ActiveRecord::Migration
  def change
    create_table :model_variations do |t|
      t.string :title
      t.string :identifier
      t.integer :model_id
      t.integer :body_type_id
      t.integer :from_year
      t.integer :to_year
      t.string :transmission
      t.string :fuel

      t.timestamps
    end
  end
end
