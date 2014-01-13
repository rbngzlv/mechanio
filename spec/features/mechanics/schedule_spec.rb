require 'spec_helper'

feature 'Mechanic schedule' do
  let(:mechanic) { create :mechanic }

  before { login_mechanic mechanic }

  subject { page }

  scenario 'check navigation' do
    visit mechanics_dashboard_path
    within('.nav-stacked') { click_link 'My Profile' }
    click_link 'Edit Profile'
    click_link 'Availabilities'
    current_path.should be_eql mechanics_events_path
    should have_selector 'li.active', text: 'My Profile'
    click_link 'Back'
    current_path.should be_eql mechanics_profile_path
  end

  context 'administrate events' do
    before { visit mechanics_events_path }

    specify 'from the begining calendar is empty' do
      should have_selector '#calendar'
      should have_no_selector '.fc-event'
      should have_selector 'h5', text: 'my days off'
    end

    specify 'show alert if user forgot to check time slot(s)' do
      click_button 'Set'
      within('.alert.alert-danger') { should have_content 'Choose time slot(s) please.' }
    end

    context 'add events for today', :js do

      scenario 'add whole day' do
        expect { set_for_today 'All' }.to change { Event.count }.by 1
        should have_content Event.last.title

        expect { set_for_today 'All' }.not_to change { Event.count }
        should have_content "is not unique event"
      end

      scenario 'add parts of day' do
        expect { set_for_today '9 AM', '11 AM' }.to change { Event.count }.by 1
        expect { set_for_today '9 AM', '11 AM' }.not_to change { Event.count }
        expect { set_for_today '9 AM' }.to change { Event.count }.by 1
        expect { set_for_today '11 AM', '3 PM' }.to change { Event.count }.by 2
        expect { set_for_today '9 AM' }.not_to change { Event.count }
        should have_content "is not unique event"
        Event.all.each { |event| should have_content event.title}
      end

      scenario 'add weekly events' do
        expect { set_recurrence_and_range_for_today 'Weekly', 'All' }.to change { Event.count }.by 1
        within('.fc-event-container') { should have_selector '.fc-event', text: Event.last.title }

        expect { set_recurrence_and_range_for_today 'Weekly', 'All' }.not_to change { Event.count }
        should have_content "is not unique event"

        expect { set_recurrence_and_range_for_today 'Weekly', '9 AM', '11 AM', '3 PM' }.to change { Event.count }.by 2
        expect { set_recurrence_and_range_for_today 'Weekly', '9 AM' }.to change { Event.count }.by 1
        Event.all.each { |event| should have_content event.title}
      end
    end

    scenario 'add repeated event which start from non today day', :js do
      checked_date = Date.parse(find('tbody tr:nth-child(2) td:nth-child(2)')['data-date'])
      expect { set_recurrence_and_range_for_box 2, 'Daily', 'All' }.to change { Event.count }.by 1
      Event.last.date_start.should == checked_date

      checked_date = Date.parse(find('tbody tr:nth-child(2) td:nth-child(2)')['data-date'])
      expect { set_recurrence_and_range_for_box 2, 'Daily', '1 PM', '5 PM' }.to change { Event.count }.by 2
      Event.last.date_start.should == checked_date

      expect { checked_date = set_recurrence_and_range_for_any_day 'Weekly', '9 AM', '1 PM', '3 PM' }.to change { Event.count }.by 2
      Event.last.date_start.should == checked_date

      expect { checked_date = set_recurrence_and_range_for_any_day 'Month', '9 AM' }.to change { Event.count }.by 1
      Event.last.date_start.should == checked_date

      expect { set_recurrence_and_range_for_any_day 'Daily', 'All' }.not_to change { Event.count }
    end

    scenario 'add unrepeated event when exists weekly dup' do
      event = create(:event, :weekly, mechanic: mechanic)
      expect { set_for_today 'All' }.to change { Event.count }.by 1
    end

    scenario 'add monthly repeated event when we have another monthly repeated event for single week day' do
      event = create(:event, mechanic: mechanic, recurrence: 'monthly', date_start: Date.today - 7.day - 8.month)
      expect { set_recurrence_and_range_for_today 'Monthly', 'All' }.to change { Event.count }.by 1
    end

    scenario 'delete "day off"', :js do
      event = create(:event, :weekly, mechanic: mechanic)

      visit mechanics_events_path

      should have_css('.fc-event', text: event.title)

      expect do
        first('.fc-event-title').click
        # It's needed to click success on confirm alert
        sleep 0.1
      end.to change { Event.count }.by -1
      should have_content 'Event succesfully deleted.'
      should have_no_content event.title
    end

    specify 'job event', :js do
      event = create :event, :with_job, mechanic: mechanic

      visit mechanics_events_path
      expect do
        find('.fc-event', text: event.title).click
        sleep 0.1
      end.not_to change { has_content?(event.title) }
    end

    def set_for_today(*time_slots)
      time_slots.each { |time_slot| check time_slot}
      click_button 'Set'
    end

    def set_recurrence_and_range_for_today(recurrence, *time_slots)
      select recurrence, from: 'event_recurrence'
      set_for_today *time_slots
    end

    def set_recurrence_and_range_for_box(box_number, recurrence, *time_slots)
        within("tbody tr:nth-child(#{box_number})") { find("td:nth-child(#{box_number})").trigger 'click' }
        select recurrence, from: 'event_recurrence'
        set_for_today *time_slots
    end

    def set_recurrence_and_range_for_any_day(recurrence, *time_slots)
      box_number = (2..4).to_a.sample
      set_recurrence_and_range_for_box(box_number, recurrence, *time_slots)
      Date.parse(find("tbody tr:nth-child(#{box_number}) td:nth-child(#{box_number})")['data-date'])
    end
  end
end
