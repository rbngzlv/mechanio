require 'spec_helper'

feature 'mechanic signin' do
  let(:mechanic) { create :mechanic }

  subject { page }

  before { visit new_mechanic_session_path }

  context 'login' do
    def signin_as_mechanic resource
      within '.wrap > .container' do
        fill_in 'mechanic_email', with: resource.email
        fill_in 'mechanic_password', with: resource.password
        click_button 'Login'
      end
    end

    scenario 'first success login' do
      signin_as_mechanic mechanic

      should have_link 'Log out'
      should have_selector('h4', text: 'Settings')
      should have_selector('li.active', text: 'Settings')
    end

    scenario 'second success login' do
      signin_as_mechanic mechanic
      within('.header') { click_link 'Log out' }
      visit new_mechanic_session_path
      signin_as_mechanic mechanic

      should have_selector('h4', text: mechanic.full_name)
      should have_selector('li.active', text: 'Dashboard')
    end

    context 'fail' do
      scenario 'with invalid information' do
        within '.wrap > .container' do
          click_button 'Login'
        end

        should have_content('Invalid email or password.')
      end

      scenario 'if mechanic suspended' do
        mechanic.suspend
        signin_as_mechanic mechanic

        should have_no_link 'Log out'
        should have_content('Your account is suspended. Please contact us to activate it.')
      end
    end
  end

  scenario 'logout' do
    login_mechanic mechanic
    visit mechanics_dashboard_path
    click_link 'Log out'

    should have_no_content mechanic.full_name
    should have_link 'Login'
  end
end
