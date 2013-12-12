require 'spec_helper'

describe 'User register', :js do

  context 'registering' do
    before do
      reset_mail_deliveries
      visit root_path
      within '.header' do
        click_link 'Sign up'
      end
    end

    it 'shows validation errors' do
      within '#register-modal' do
        click_button 'Sign up'
      end

      page.should have_css '.help-block', text: "can't be blank"
    end

    it 'redirects to dashboard' do
      within '#register-modal' do
        fill_in 'First name', with: 'First'
        fill_in 'Last name', with: 'Last'
        fill_in 'Email', with: 'user@host.com'
        fill_in 'Password', with: 'password'
        click_button 'Sign up'
      end

      page.should have_css 'li.active', text: 'Dashboard'
      page.should have_css '.alert', text: 'Welcome! You have signed up successfully.'

      mail_deliveries.count.should eq 1
    end
  end
end
