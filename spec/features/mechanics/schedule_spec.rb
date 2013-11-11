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
    current_path.should be_eql edit_mechanics_profile_path
  end

  context 'administrate events', :js do
    scenario 'add "days off"' do
      visit mechanics_events_path

      should have_selector '#calendar'
      should have_no_selector '.fc-event'

      expect do
        check 'Sunday'
        check 'Monday'
        click_button 'Set'
      end.to change { Event.count }.by 2
      within('.fc-event-container') { has_css?('.fc-event', text: "Day off", count: 2*6).should be_true }

      expect do
        check 'Sunday'
        click_button 'Set'
      end.not_to change { Event.count }
      should have_content "Sunday is not unique"
    end

    scenario 'delete "day off"' do
      event = create(:event, :day_off, mechanic: mechanic)

      visit mechanics_events_path

      should have_content event.title
      has_css?('.fc-event', text: event.title, count: 6).should be_true

      expect do
        first('.fc-event-title').click
        # It's needed to click success on confirm alert
        sleep 0.1
      end.to change { Event.count }.by -1
      should have_content 'Event succesfully deleted.'
      should have_no_content event.title
    end
  end
end
