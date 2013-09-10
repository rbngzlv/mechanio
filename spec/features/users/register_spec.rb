require 'spec_helper'

describe 'User register' do
  
  it 'show registration page' do
    visit root_path
    click_link 'Sign up'

    page.should have_css 'h2', text: 'Sign up'
    page.should have_field 'First name'
    page.should have_field 'Last name'
    page.should have_field 'Email'
    page.should have_field 'Password'
  end

  context 'registering' do
    before do
      visit new_user_registration_path
    end

    it 'shows validation errors' do
      click_button 'Sign up'

      page.should have_css '.help-block', text: "can't be blank"
    end
    
    it 'redirects to dashboard' do

      fill_in 'First name', with: 'First'
      fill_in 'Last name', with: 'Last'
      fill_in 'Email', with: 'user@host.com'
      fill_in 'Password', with: 'password'
      click_button 'Sign up'

      page.should have_css 'h4', text: 'Dashboard'
      page.should have_css '.alert', text: 'Welcome! You have signed up successfully.'
    end
  end
end
