class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.string :title
      t.string :code
      t.string :discount_type
      t.decimal :discount_value, precision: 8, scale: 2
      t.integer :uses_left, default: nil
      t.date :starts_at, default: nil
      t.date :ends_at, default: nil

      t.timestamps

      t.index :code
    end
  end
end
