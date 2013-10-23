shared_examples 'settings page' do
  let(:account) { create role, password: 'old_password' }

  subject { page }

  before do
    send "login_#{role}", account
  end

  specify 'dashboard should have link to settings' do
    visit send "#{role}s_dashboard_path"
    within('.nav-stacked') { click_link 'Settings' }
    should have_selector('li.active', text: 'Settings')
    current_path.should be_eql send "edit_#{role}s_settings_path"
  end

  context 'update password' do
    before { visit send "edit_#{role}s_settings_path" }

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
