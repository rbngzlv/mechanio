class ConvertEventDateToTime < ActiveRecord::Migration
  def up
    add_column :events, :start_time, :timestamp
    add_column :events, :end_time, :timestamp

    Event.all.each do |e|
      e.start_time = e.date_start.in_time_zone.change(hour: e.time_start.hour, min: 0)
      e.end_time   = e.date_start.in_time_zone.change(hour: e.time_end.hour, min: 0)
      e.save
    end

    remove_column :events, :date_start
    remove_column :events, :time_start
    remove_column :events, :time_end
    remove_column :events, :recurrence_end
    rename_column :events, :date_end, :occurs_until
  end

  def down
    add_column :events, :date_start, :date
    add_column :events, :time_start, :time
    add_column :events, :time_end, :time
    add_column :events, :recurrence_end, :date
    rename_column :events, :occurs_until, :date_end

    Event.all.each do |e|
      e.date_start = e.start_time
      e.time_start = e.start_time
      e.time_end = e.end_time
      e.save
    end

    remove_column :events, :start_time
    remove_column :events, :end_time
  end
end
