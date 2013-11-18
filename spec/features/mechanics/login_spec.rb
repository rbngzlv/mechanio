require 'spec_helper'

feature 'mechanic signin' do
  let(:mechanic) { create :mechanic }

  subject { page }

  before { visit new_mechanic_session_path }

  context 'login' do

    scenario 'success' do
      fill_in 'mechanic_email', with: mechanic.email
      fill_in 'mechanic_password', with: mechanic.password
      click_button 'Login'
      should have_content('Signed in successfully.')
      should have_selector('h4', text: mechanic.full_name)
      should have_selector('li.active', text: 'Dashboard')
    end

    context 'fail' do
      before { click_button 'Login' }

      it { should have_content('Invalid email or password.') }
    end
  end

  context 'logout' do
    before do
      login_mechanic mechanic

      visit mechanics_dashboard_path

      click_link 'Log out'
    end

    it { should have_no_content mechanic.full_name }
    it { should have_link 'Login' }
  end
end
