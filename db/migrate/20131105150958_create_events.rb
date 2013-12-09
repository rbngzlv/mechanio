class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.date :date_start
      t.date :date_end
      t.date :recurrence_end
      t.time :time_start
      t.time :time_end
      t.string :recurrence
      t.string :title
      t.integer :mechanic_id

      t.timestamps
    end
  end
end
