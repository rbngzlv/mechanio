require 'spec_helper'

feature 'user settings page' do
  let(:user) { create :user, password: 'old_password' }

  subject { page }

  before do
    login_user user
  end

  specify 'dashboard should have link to settings' do
    visit users_dashboard_path
    within('.nav-stacked') { click_link 'Settings' }
    should have_selector('li.active', 'Settings')
    current_path.should be_eql edit_users_settings_path
  end

  context 'update password' do
    before { visit edit_users_settings_path }

    scenario 'success' do
      fill_in 'Old Password', with: 'old_password'
      fill_in 'New Password', with: 'new_password'
      fill_in 'Confirm Password', with: 'new_password'
      click_button 'Save'
      should have_content 'Your password successfully updated.'
    end

    context 'fail' do
      scenario 'sand empty form' do
        click_button 'Save'
        should have_content "can't be blank"
      end
    end
  end
end
