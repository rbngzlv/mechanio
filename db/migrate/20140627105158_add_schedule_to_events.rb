class AddScheduleToEvents < ActiveRecord::Migration
  def up
    add_column :events, :schedule, :text

    Event.all.each do |e|
      start = e.date_start.in_time_zone
      start = start.change(hour: e.time_start.hour, min: 0) if e.time_start

      schedule = IceCube::Schedule.new(start)

      if e.recurrence
        rule = IceCube::Rule.send(e.recurrence)
        rule = rule.count(e.count) if e.count
        rule = rule.until(e.date_end) if e.date_end
        schedule.add_recurrence_rule(rule)
      end

      e.schedule = schedule.to_hash
      e.save
    end
  end

  def down
    remove_column :events, :schedule
  end
end
