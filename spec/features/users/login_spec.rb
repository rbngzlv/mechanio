require 'spec_helper'

describe 'User login' do

  let(:user) { create :user }

  it 'shows login page' do
    visit root_path
    click_link 'Login'

    page.should have_css 'h2', text: 'Login'
    page.should have_field 'Email'
    page.should have_field 'Password'
    page.should have_button 'Login'
  end

  context 'logging in' do
    before do
      visit new_user_session_path
    end

    it 'shows an error on invalid login' do
      fill_in 'Email', with: 'unknown@host.com'
      fill_in 'Password', with: 'password'
      click_button 'Login'

      page.should have_css '.alert', text: 'Invalid email or password.'
    end

    it 'loggs user in' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'

      page.should have_css '.alert', text: 'Signed in successfully.'
      page.should have_css 'h4', text: 'Dashboard'
      page.should have_link 'Logout'
    end
  end

  it 'logs user out' do
    login_user

    visit users_dashboard_path

    click_link 'Logout'

    page.should have_css '.alert', text: 'Signed out successfully.'
    page.should have_link 'Login'
  end
end
