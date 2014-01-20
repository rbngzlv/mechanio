require 'spec_helper'

describe 'User login', :js do

  let(:user) { create :user }

  subject { page }

  context 'logging in' do
    before do
      visit root_path
      within '.header' do
        click_link 'Login'
      end
    end

    it { should have_selector "a.facebook-link"}
    it { should have_selector "a.gmail-link"}

    it 'shows an error on invalid login' do
      login_with email: 'unknown@host.com', password: 'password'

      should have_css '.alert', text: 'Invalid email or password.'
    end

    it 'loggs user in' do
      login_with email: user.email, password: user.password

      should have_css '.alert', text: 'Signed in successfully.'
      should have_css 'li.active', text: 'Dashboard'
    end
  end

  it 'logs user out' do
    login_user
    visit users_dashboard_path
    click_button user.first_name
    click_link 'Log out'

    should have_link 'Login'
  end

  it 'recover password' do
    reset_mail_deliveries
    user
    visit root_path
    within('.header') { click_link 'Login' }
    click_link 'Reset it here'
    within '#recover-modal' do
      fill_in 'Email', with: user.email
      click_button 'Reset Password'
    end

    mail_deliveries.count.should eq 1
    mail_deliveries[0].tap do |m|
      m.to.should eq [user.email]
      m.body.should include 'Change my password'
      m.body.encoded.should match edit_user_password_path
      m.body.encoded.should match user.reload.reset_password_token
      m.subject.should eq 'Reset password instructions'
    end
  end

  def login_with(params)
    within '#login-modal' do
      fill_in 'Email', with: params[:email]
      fill_in 'Password', with: params[:password]
      click_button 'Login'
    end
  end
end
