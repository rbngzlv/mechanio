$ = jQuery

$.fn.extend
  book_calendar: (options) ->
    calendar = this.find('.calendar')
    left_arrow = this.find('.left-arrow')
    right_arrow = this.find('.right-arrow')
    form = this.find('form')

    calendar.fullCalendar({
      header: { left: '', center: '', right: '' },
      defaultView: 'agendaWeek',
      firstDay: options.firstDay,
      year: options.year,
      month: options.month,
      date: options.date,
      firstHour: 9,
      minTime: 9,
      maxTime: 19,
      slotMinutes: 120,
      allDayDefault: false,
      allDaySlot: false,
      timeFormat: { agenda: '' },
      selectable: true,
      events: options.events,

      eventClick: (event) ->
        return false

      dayClick: (date, allDay, jsEvent, view) ->
        form.find('#job_scheduled_at').val(moment(date).format('YYYY-MM-DDTHH:mm'))
        $('.choose_mechanic_form :submit').prop('disabled', true)
        form.find(':submit').prop('disabled', false)

      viewRender: (view, element) ->
        start_date = moment().add('days', 1)
        end_date = moment().add('days', 14)
        left_arrow.toggleClass('disabled', start_date.isAfter(view.start))
        right_arrow.toggleClass('disabled', !end_date.isAfter(view.end))

      eventAfterRender: (event, element, view) ->
        el = $(element)
        wrapper = $('.fc-content > div > div > div')

        width = parseInt(el.css('width'))
        height = parseInt(el.css('height'))
        wrapper_height = parseInt(wrapper.css('height'))

        width *= 1.04
        height *= 1.04
        wrapper_height *= 1.04

        el.css('width', width + 'px')
        el.css('height', height + 'px')
        wrapper.css('height', wrapper_height + 'px')

        $('.fc-content > div > div > div > div').css('overflow', 'visible')
    })

    right_arrow.click ->
      if (!$(this).hasClass('disabled'))
        calendar.fullCalendar('next')

    left_arrow.click ->
      if (!$(this).hasClass('disabled'))
        calendar.fullCalendar('prev')
