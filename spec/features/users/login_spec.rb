require 'spec_helper'

describe 'User login', :js do

  let(:user) { create :user }

  context 'logging in' do
    before do
      visit root_path
      within '.header' do
        click_link 'Login'
      end
    end

    it 'shows an error on invalid login' do
      login_with email: 'unknown@host.com', password: 'password'

      page.should have_css '.alert', text: 'Invalid email or password.'
    end

    it 'loggs user in' do
      login_with email: user.email, password: user.password

      page.should have_css '.alert', text: 'Signed in successfully.'
      page.should have_css 'li.active', text: 'Dashboard'
    end
  end

  it 'logs user out' do
    login_user
    visit users_dashboard_path
    click_button user.first_name
    click_link 'Log out'

    page.should have_link 'Login'
  end

  def login_with(params)
    within '#login-modal' do
      fill_in 'Email', with: params[:email]
      fill_in 'Password', with: params[:password]
      click_button 'Login'
    end
  end
end
