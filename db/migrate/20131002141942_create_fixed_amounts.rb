class CreateFixedAmounts < ActiveRecord::Migration
  def change
    create_table :fixed_amounts do |t|
      t.integer :task_id
      t.string :description
      t.decimal :cost, precision: 8, scale: 2
      t.decimal :tax, precision: 8, scale: 2
      t.decimal :total, precision: 8, scale: 2

      t.timestamps
    end
  end
end
