require 'spec_helper'

describe 'User register', :js do

  let!(:sydney) { create :sydney_suburb }

  specify 'social networks registration popup' do
    visit root_path
    within '.header' do
      click_link 'Sign up'
    end
    within '#social-login-modal' do

      find('a.facebook-link')[:href].should be_eql '/users/auth/facebook'
      find('a.google_oauth2-link')[:href].should be_eql '/users/auth/google_oauth2'
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
    end

    it 'shows validation errors' do
      visit root_path
      open_signup_popup
      within '#register-modal' do
        click_button 'Sign up'
      end

      page.should have_css '.help-block', text: "can't be blank"
    end

    it 'redirects to homepage' do
      visit root_path
      open_signup_popup
      register
      current_path.should == root_path
      page.should have_link 'Car Needs Servicing'
      page.should have_css '.dropdown button', text: 'John'

      mail_deliveries.count.should eq 1
    end

    it 'redirects to previous url' do
      visit users_cars_path
      open_signup_popup
      register
      page.should have_css 'h4', text: 'My Cars'
    end

    it 'creates a location association with postcode' do
      visit users_cars_path
      open_signup_popup
      register

      User.last.location.suburb.name.should eq 'Sydney'
    end

    it 'registeres via referrer' do
      referrer = create :user, first_name: 'John', last_name: 'Snow'
      visit referrer_users_invitations_path(referrer.referral_code)

      click_sign_in
      within '#social-login-modal' do
        page.should have_content "You've been invited by John Snow to use Mechanio."
      end

      open_regular_signup
      register

      User.last.referred_by.should eq referrer.id
    end

    def register
      within '#register-modal' do
        fill_in 'First name', with: 'John'
        fill_in 'Last name', with: 'Last'
        fill_in 'Email', with: 'user@host.com'
        autocomplete 'Suburb', 'syd', 'Sydney, NSW 2012'
        fill_in 'Password (Minimum 8 Characters)', with: 'password'
        fill_in 'Confirm password', with: 'password'
        click_button 'Sign up'
      end
    end

    def click_sign_in
      within '.header' do
        find_link('Sign up').trigger('click')
      end
    end

    def open_signup_popup
      click_sign_in
      open_regular_signup
    end

    def open_regular_signup
      within '#social-login-modal' do
        click_link 'Use regular email sign up'
      end
    end
  end
end
