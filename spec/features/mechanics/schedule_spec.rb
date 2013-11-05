require 'spec_helper'

feature 'Mechanics schedule' do
  before { login_mechanic }

  scenario 'check navigation' do
    visit mechanics_dashboard_path
    within('.nav-stacked') { click_link 'My Profile' }
    click_link 'Edit Profile'
    click_link 'Availabilities'
    current_path.should be_eql mechanics_schedule_path
    page.should have_selector 'li.active', text: 'My Profile'
    click_link 'Back'
    current_path.should be_eql edit_mechanics_profile_path
  end

  context 'mechanic without events' do
    before { visit mechanics_schedule_path }

    it { page.should have_selector '#calendar' }
  end
end
