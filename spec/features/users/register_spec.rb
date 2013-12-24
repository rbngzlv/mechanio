require 'spec_helper'

describe 'User register', :js do

  specify 'social networks registration popup' do
    visit root_path
    within '.header' do
      click_link 'Sign up'
    end
    within '#social-login-modal' do

      page.should have_link 'facebook-link', href: '/users/auth/facebook'
      page.should have_link 'gmail-link', href: '/users/auth/google_oauth2'
      page.should have_content 'Sign up with Mechanio to book reliable mobile mechanics'
      page.should have_link 'Use regular email sign up'
      page.should have_link 'Log in'

      find('.close').click
    end
    page.should_not have_selector '#social-login-modal'
  end

  context 'registering' do
    before do
      reset_mail_deliveries
      visit root_path
      within '.header' do
        click_link 'Sign up'
      end
      click_link 'Use regular email sign up'
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
