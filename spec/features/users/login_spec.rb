require 'spec_helper'

describe 'User login', :js do

  let(:user) { create :user }

  subject { page }

  context 'logging through social networks', :pending do
    before { visit root_path }

    specify 'UI' do
      click_link 'Login'

      should have_content 'Sign up with Mechanio to book reliable mobile mechanics'
      should have_link 'Use reqular email sign up'
      should have_link 'Log in'
    end
    specify 'logging through facebook' do

    end
    specify 'logging through gmail' do
    end
    it 'should could be closable'
  end

  context 'logging in', :pending do
    before do
      visit root_path
      within '.header' do
        click_link 'Login'
      end
    end

    it 'navigation' do
      should have_link "SoCial connections"
    end

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

  def login_with(params)
    within '#login-modal' do
      fill_in 'Email', with: params[:email]
      fill_in 'Password', with: params[:password]
      click_button 'Login'
    end
  end
end
