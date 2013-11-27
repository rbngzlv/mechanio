class EventsManager < Struct.new(:mechanic)
  include IceCube

  def add_events(params)
    params[:recurrence] = (rec = params[:recurrence]) == 'Does not recur' ? nil : rec.downcase
    params[:date_start] = Date.parse(params[:date_start])
    params[:mechanic_id] = mechanic.id

    unless time_slots = distribute_time_slots(params.delete(:time_slots), params[:date_start])
      errors[:time_slots] << 'no time slots'
      return false
    end

    time_slots.each do |time_slot|
      if time_slot
        params[:time_start] = time_slot[0]
        params[:time_end] = params[:time_start] + time_slot[1].hour
      end
      e = Event.new(params.permit(:date_start, :title, :recurrence, :mechanic_id, :time_start, :time_end))
      unless e.save
        errors[:uniqueness] << e.title
      end
    end
    errors[:uniqueness].length == 0 ? true : false
  end

  def errors
    @errors ||= { uniqueness: [], time_slots: []}
  end

  def errors_full_message
    return 'Choose time slot(s) please.' if errors[:time_slots].present?
    tmp_errors = errors[:uniqueness]
    is_single = tmp_errors.length == 1
    "#{tmp_errors.map(&:capitalize).join(', ')} #{ is_single ? 'is' : 'are' } not unique event#{ 's' unless is_single}"
  end

  def distribute_time_slots(time_slots, date_start)
    time_slots.reject!(&:empty?)
    return false if time_slots.empty?
    return [nil] if time_slots.include?('All') || time_slots.length == 5
    previous_delta = 0
    time_ranges = []
    time_slots.each do |time_slot|
      delta = time_slot.to_i
      if delta == previous_delta + 2
        time_ranges.last[1] += 2
      else
        time_ranges << [date_start + delta.hour, 2]
      end
      previous_delta = delta
    end
    time_ranges
  end

  def events_list
    events = mechanic.events.map do |event|
      if (repeat = event.recurrence)
        schedule = Schedule.new(event.date_start)
        schedule.add_recurrence_rule(Rule.send repeat)
        schedule.occurrences_between(Date.today - 1.year,Date.today + 1.year).map do |occurrence|
          hash_for_fullcalendar event, occurrence
        end
      else
        hash_for_fullcalendar event
      end
    end.flatten
  end

  def hash_for_fullcalendar(event, occurrence = nil)
    occurrence ||= event.date_start
    time_start, time_end = get_time_start_and_end(event, occurrence)
    { start: time_start, :end => time_end, title: event.title, url: Rails.application.routes.url_helpers.mechanics_event_path(event.id), id: event.id }
  end

  def check_uniqueness(event)
    t = time_for_compearing(event.time_end)
    mechanic.events.send(:repeated, event.recurrence).time_slot(event.time_start).each do |e|
      if event.recurrence
        schedule = Schedule.new(e.date_start)
        schedule.add_recurrence_rule Rule.send event.recurrence
        return false if schedule.occurs_at?(event.date_start) and e.time_end == t
      else
        return false if e.date_start == event.date_start and e.time_end == t
      end
    end
    true
  end

  def time_for_compearing(t)
    t ? t.to_time.change({:year => 2000 , :month => 1 , :day => 1 }) : nil
  end

  def unavailable_at?(scheduled_at)
    mechanic.events.map do |event|
      start_time, end_time = get_time_start_and_end(event)
      schedule = Schedule.new(start_time, end_time: end_time)
      if (repeat = event.recurrence)
        schedule.add_recurrence_rule(Rule.send repeat)
      end
      return true if schedule.occurring_at?(scheduled_at)
    end
    false
  end

  def get_time_start_and_end(event, occurrence = nil)
    occurrence ||= event.date_start
    if event.time_start
      [occurrence + event.time_start.hour.to_i.hour, occurrence + event.time_end.hour.to_i.hour]
    else
      [occurrence + 9.hour, occurrence + 19.hour]
    end
  end
end
