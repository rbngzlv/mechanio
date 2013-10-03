class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.integer :task_id
      t.string :name
      t.integer :quantity
      t.decimal :cost, precision: 8, scale: 2
      t.decimal :tax, precision: 8, scale: 2
      t.decimal :total, precision: 8, scale: 2

      t.timestamps
    end
  end
end
