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

    it 'redirect to previous url if exists' do
      visit users_cars_path
      within '.header' do
        click_link 'Login'
      end
      login_with email: user.email, password: user.password
      should have_css 'h4', text: 'My Cars'
    end
  end

  it 'logs user out' do
    login_user
    visit users_dashboard_path
    click_button user.first_name
    click_link 'Log out'

    should have_link 'Login'
  end

  def login_with(params)
    within '#login-modal' do
      fill_in 'Email', with: params[:email]
      fill_in 'Password', with: params[:password]
      click_button 'Login'
    end
  end
end
