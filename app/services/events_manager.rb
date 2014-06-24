class EventsManager < Struct.new(:mechanic)
  include IceCube

  def create_event(params)
    time_start = Time.now.change(hour: params[:time_start], minute: 0) if params[:time_start]
    time_end   = Time.now.change(hour: params[:time_end], minute: 0) if params[:time_end]

    attrs = {
      date_start:  Date.parse(params[:date_start]),
      mechanic_id: mechanic.id,
      time_start:  time_start,
      time_end:    time_end
    }

    if params[:repeat] == 'true'
      attrs[:recurrence] = params[:recurrence].downcase

      case params[:ends]
      when 'count'
        attrs[:count] = params[:ends_after_count]
      when 'date'
        attrs[:date_end] = Date.parse(params[:ends_on])
      end
    end

    Event.create(attrs)
  end

  def delete_event(event_id)
    event = mechanic.events.find(event_id)
    event.is_appointment? ? false : event.destroy
  end

  def events_list
    events = mechanic.events.includes(:job).map do |event|
      if event.recurrence
        schedule = get_schedule(event, event.date_start)

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
    { start: time_start,
      end: time_end,
      title: event.title,
      url: Rails.application.routes.url_helpers.mechanics_event_path(event.id),
      id: event.id,
      className: event.job ? 'work' : 'day-off' }
  end

  def check_uniqueness(event)
    t = time_for_compearing(event.time_end)
    mechanic.events.send(:repeated, event.recurrence).time_slot(event.time_start).each do |e|
      if event.recurrence
        schedule = get_schedule(event, e.date_start)

        return false if schedule.occurs_at?(event.date_start) and e.time_end == t
      else
        return false if e.date_start == event.date_start and e.time_end == t
      end
    end
    true
  end

  def time_for_compearing(t)
    t ? t.in_time_zone.change({:year => 2000 , :month => 1 , :day => 1 }) : nil
  end

  def available_at?(scheduled_at)
    mechanic.events.map do |event|
      start_time, end_time = get_time_start_and_end(event)
      schedule = get_schedule(event, start_time, end_time: end_time)

      return false if schedule.occurring_at?(scheduled_at.in_time_zone)
    end
    true
  end

  def get_time_start_and_end(event, occurrence = nil)
    occurrence ||= event.date_start
    if event.time_start
      [occurrence + event.time_start.hour.hours, occurrence + event.time_end.hour.hours]
    else
      [occurrence.in_time_zone, occurrence.in_time_zone.advance(hours: 23, minutes: 59)]
    end
  end

  def get_schedule(event, start, options = {})
    schedule = Schedule.new(start, options)
    if event.recurrence
      rule = Rule.send(event.recurrence)
      rule = rule.count(event.count) if event.count
      rule = rule.until(event.date_end) if event.date_end
      schedule.add_recurrence_rule(rule)
    end
    schedule
  end
end
