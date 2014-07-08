class EventsManager < Struct.new(:mechanic)
  include IceCube

  def create_event(params)
    start_date = Date.parse(params[:start_date]).in_time_zone

    attrs = {
      mechanic_id: mechanic.id,
      start_time:  start_date.change(hour: params[:start_time], minute: 0),
      end_time:    start_date.change(hour: params[:end_time], minute: 0)
    }

    if to_boolean(params[:repeat]) == true
      attrs[:recurrence] = params[:recurrence].downcase

      case params[:ends]
      when 'count'
        attrs[:count] = params[:ends_after_count]
      when 'date'
        attrs[:occurs_until] = Date.parse(params[:ends_on])
      end
    end

    Event.create(attrs)
  end

  def delete_occurence(event_id, date)
    event = mechanic.events.find(event_id)
    start_hour = event.start_time.hour
    time = Time.zone.parse(date).change(hour: start_hour)

    event.add_exception_time(time)
    event.save
  end

  def delete_event(event_id)
    event = mechanic.events.find(event_id)
    event.is_appointment? ? false : event.destroy
  end

  def events_list
    mechanic.events.includes(:job).map do |event|
      event.schedule.occurrences_between(Date.today - 1.year, Date.today + 1.year).map do |occurrence|
        hash_for_fullcalendar(event, occurrence)
      end
    end.flatten
  end

  def hash_for_fullcalendar(event, occurrence)
    start_time = occurrence.change(hour: event.start_time.hour)
    end_time   = occurrence.change(hour: event.end_time.hour)
    url = routes.mechanics_events_path(event.id)

    {
      start:  start_time,
      end:    end_time,
      title:  event.title,
      url:    url,
      id:     event.id,
      className: event.job ? 'work' : 'day-off'
    }
  end

  def available_at?(scheduled_at)
    !mechanic.events.any? do |event|
      event.schedule.occurring_at?(scheduled_at.in_time_zone)
    end
  end


  private

  def to_boolean(string)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(string)
  end

  def routes
    Rails.application.routes.url_helpers
  end
end
