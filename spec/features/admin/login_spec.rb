require 'spec_helper'

describe 'Admin login' do

  let(:admin) { create :admin }

  context 'logging in' do
    before do
      visit new_admin_session_path
    end

    it 'shows an error on invalid login' do
      fill_in 'Email', with: 'unknown@host.com'
      fill_in 'Password', with: 'password'
      click_button 'Login'

      page.should have_css '.alert', text: 'Invalid email or password.'
    end

    it 'loggs admin in' do
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_button 'Login'

      page.should have_css '.alert', text: 'Signed in successfully.'
      page.should have_css 'h4', text: 'Dashboard'
      page.should have_link 'Logout'
    end
  end

  it 'logs admin out' do
    login_admin

    visit admin_dashboard_path

    click_link 'Logout'

    page.should have_link 'Login'
  end
end
