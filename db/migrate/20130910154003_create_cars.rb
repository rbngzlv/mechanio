class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.integer :user_id
      t.integer :model_variation_id
      t.integer :year

      t.timestamps
    end
  end
end
