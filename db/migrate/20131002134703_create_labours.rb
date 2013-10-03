class CreateLabours < ActiveRecord::Migration
  def change
    create_table :labours do |t|
      t.integer :task_id
      t.text :description
      t.integer :duration
      t.decimal :hourly_rate, precision: 8, scale: 2
      t.decimal :cost, precision: 8, scale: 2
      t.decimal :tax, precision: 8, scale: 2
      t.decimal :total, precision: 8, scale: 2

      t.timestamps
    end
  end
end
