require 'spec_helper'

feature 'Mechanic schedule' do
  let(:mechanic)     { create :mechanic }
  let(:month_start)  { Time.now.change(day: 1).to_s(:day_month) }

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
      first('.fc-day').click
    end

    scenario 'non-recurring event' do
      within '.event_repeat' do
        page.should have_checked_field 'event_repeat_false'
      end
      page.should have_no_css 'h4', text: 'Repeat'

      select_time '9 AM', '1 PM'
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

      page.should have_css '.fc-event', text: "daily from #{month_start}, 9 AM - 11 AM", count: 42
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

      page.should have_css '.fc-event', text: "daily from #{month_start}, 9 AM - 11 AM", count: 3
    end

    scenario 'daily event with date limit' do
      within '.event_repeat' do
        page.choose 'Yes'
      end

      page.should have_css 'h4', text: 'Repeat'
      page.should have_select 'event_recurrence', selected: 'Daily'

      find('#event_ends_on').click
      within '.datepicker-days' do
        all('.day').last.click
      end
      page.should have_checked_field 'event_ends_date'

      click_on 'Set'

      page.should have_css '.fc-event', text: "daily from #{month_start}, 9 AM - 11 AM", count: 35
    end

    scenario 'delete blocked timeslot' do
      event = create(:event, :daily, mechanic: mechanic)
      visit mechanics_events_path

      page.should have_css '.fc-event', text: event.title

      first('.fc-event').click

      page.should have_no_css '.fc-event', text: event.title
      page.should have_content 'Event successfully deleted'
    end

    specify 'job event', :js do
      event = create :event, job: create(:job, :with_service), mechanic: mechanic

      visit mechanics_events_path

      expect do
        find('.fc-event', text: event.title).click
        sleep 0.1
      end.not_to change { has_content?(event.title) }
    end

    def within_modal(&block)
      within '#block-timeslot-modal' do
        yield
      end
    end

    def select_time(from, to)
      within_modal do
        select from, from: 'event_time_start'
        select to,   from: 'event_time_end'
      end
    end
  end
end
