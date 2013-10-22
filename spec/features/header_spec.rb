require 'spec_helper'

feature 'navigation in header' do
  scenario 'user' do
    login_user
    visit users_dashboard_path
    within 'header' do
      click_link 'My Estimates'
      current_path.should be_eql users_estimates_path
      click_link 'My Appointments'
      current_path.should be_eql users_appointments_path
      click_link 'My Cars'
      current_path.should be_eql users_cars_path
      click_link 'My Profile'
      current_path.should be_eql users_profile_path
      click_link 'Dashboard'
      current_path.should be_eql users_dashboard_path
      click_link 'Log out'
      current_path.should be_eql root_path
    end
  end

  scenario 'mechanic' do
    login_mechanic
    visit mechanics_dashboard_path
    within 'header' do
      click_link 'My Profile'
      current_path.should be_eql mechanics_profile_path
      click_link 'Dashboard'
      current_path.should be_eql mechanics_dashboard_path
      click_link 'Log out'
      current_path.should be_eql root_path
    end
  end
end
