require 'spec_helper'

feature 'Mechanic schedule' do
  let(:mechanic)     { create :mechanic }

  before do
    login_mechanic mechanic
  end

  scenario 'check navigation' do
    visit mechanics_dashboard_path
    within('.nav-stacked') { click_link 'My Calendar' }

    page.should have_css '.nav-stacked .active a', text: 'My Calendar'
    page.should have_css '#calendar'
    page.should have_no_css '.fc-event'
  end

  context 'administrate events', :js do
    before do
      visit mechanics_events_path

      day = first('.fc-week.fc-last .fc-day')
      @selected_date = Date.parse(day['data-date']).in_time_zone.to_s(:day_month)
      day.click
    end

    scenario 'non-recurring event' do
      within '.event_repeat' do
        page.should have_checked_field 'event_repeat_false'
      end
      page.should have_no_css 'h4', text: 'Repeat'

      within '#block-timeslot-modal' do
        select '9 AM', from: 'event_start_time'
        select '1 PM',   from: 'event_end_time'
      end

      click_on 'Set'

      page.should have_css '.fc-event', text: '9 AM - 1 PM', count: 1
    end

    scenario 'daily event' do
      within '.event_repeat' do
        choose 'Yes'
      end

      page.should have_css 'h4', text: 'Repeat'
      page.should have_select 'event_recurrence', selected: 'Daily'
      within '.ends-on' do
        page.should have_checked_field 'event_ends_never'
      end

      click_on 'Set'

      page.should have_css '.fc-event', text: "daily from #{@selected_date}, 9 AM - 11 AM", count: 7
    end

    scenario 'daily event with count limit' do
      within '.event_repeat' do
        page.choose 'Yes'
      end

      page.should have_css 'h4', text: 'Repeat'
      page.should have_select 'event_recurrence', selected: 'Daily'
      within '.ends-on' do
        fill_in 'event_ends_after_count', with: 3
        page.should have_checked_field 'event_ends_count'
      end

      click_on 'Set'

      page.should have_css '.fc-event', text: "daily from #{@selected_date}, 9 AM - 11 AM", count: 3
    end

    scenario 'daily event with date limit' do
      within '.event_repeat' do
        page.choose 'Yes'
      end

      page.should have_css 'h4', text: 'Repeat'
      page.should have_select 'event_recurrence', selected: 'Daily'

      find('#event_ends_on').click
      within '.datepicker-days' do
        all('.day')[-2].click
      end

      page.should have_checked_field 'event_ends_date'

      click_on 'Set'

      page.should have_css '.fc-event', text: "daily from #{@selected_date}, 9 AM - 11 AM", count: 6
    end

    scenario 'delete all occurences' do
      event = create(:event, count: 3, recurrence: 'daily', mechanic: mechanic)
      visit mechanics_events_path

      page.should have_css '.fc-event', text: event.title, count: 3

      first('.fc-event').click
      within '#delete-timeslot-modal' do
        choose 'Delete all recurring entries'
        click_on 'Delete'
      end

      page.should have_no_css '.fc-event'
    end

    scenario 'delete single occurence' do
      event = create(:event, count: 3, recurrence: 'daily', mechanic: mechanic)
      visit mechanics_events_path

      page.should have_css '.fc-event', text: event.title, count: 3

      first('.fc-event').click
      within '#delete-timeslot-modal' do
        choose 'Delete this entry'
        click_on 'Delete'
      end

      page.should have_css '.fc-event', text: event.title, count: 2
    end

    specify 'job event', :js do
      event = create :event, job: create(:job, :with_service), mechanic: mechanic

      visit mechanics_events_path

      expect do
        find('.fc-event', text: event.title).click
        sleep 0.1
      end.not_to change { has_content?(event.title) }
    end
  end
end
