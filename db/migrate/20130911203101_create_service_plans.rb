class CreateServicePlans < ActiveRecord::Migration
  def change
    create_table :service_plans do |t|
      t.string :title
      t.integer :kms_travelled
      t.integer :months
      t.decimal :quote, precision: 8, scale: 2
      t.integer :make_id
      t.integer :model_id
      t.integer :model_variation_id
      t.text :inclusions
      t.text :instructions
      t.text :parts
      t.text :notes

      t.timestamps
    end
  end
end
