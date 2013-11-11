class EventsManager < Struct.new(:mechanic)
  include IceCube

  def add_events(params)
    days = params.delete(:days_off)
    days.each do |day|
      unless day == ""
        date  = Date.parse(day)
        delta = date > Date.today ? 0 : 7
        params[:date_start] = date + delta - 8.week
        params[:mechanic_id] = mechanic.id
        e = Event.new(params.permit(:date_start, :title, :recurrence, :mechanic_id))
        unless e.save
          events_with_errors << day
        end
      end
    end
    events_with_errors.length == 0 ? true : false
  end

  def events_with_errors
    @events_with_errors ||= []
  end

  def errors_full_message
    errors = events_with_errors
    is_single = errors.length == 1
    "#{errors.map(&:capitalize).join(', ')} #{ is_single ? 'is' : 'are' } not unique event#{ 's' unless is_single}"
  end

  def events_list
    events = mechanic.events.map do |event|
      if (repeat = event.recurrence)
        schedule = Schedule.new(event.date_start)
        schedule.add_recurrence_rule(Rule.send repeat)
        schedule.occurrences_between(Date.today - 1.year,Date.today + 1.year).map do |occurrence|
          { start: occurrence, title: event.title, url: Rails.application.routes.url_helpers.mechanics_event_path(event.id), id: event.id }
        end
      else
        { start: event.date_start, title: event.title, url: Rails.application.routes.url_helpers.mechanics_event_path(event.id), id: event.id }
      end
    end.flatten(1)
  end

  def check_date(date_start)
    events = mechanic.events.weekly.map do |event|
      schedule = Schedule.new(event.date_start)
      schedule.add_recurrence_rule Rule.send :weekly
      if schedule.occurs_at? date_start
        return false
      end
    end
    true
  end
end
