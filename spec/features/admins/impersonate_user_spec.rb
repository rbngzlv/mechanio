require 'spec_helper'

describe 'Admin can switch to any users account' do

  let!(:admin) { create :admin }
  let!(:user)  { create :user, first_name: 'John', last_name: 'Zorn' }

  specify 'admin switches to users account and back' do
    visit new_admin_session_path

    within '.wrap > .container' do
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_on 'Login'
    end

    page.should have_css 'h4', text: 'Dashboard'
    page.should have_css 'dl', text: 'Total users 1 Total mechanics 0'

    within('.navbar')   { click_on 'Users' }
    within('tbody tr')  { click_on 'Login' }

    page.should have_content "Logged in as #{user.full_name}"

    within('.dropdown') { click_on 'My Appointments' }
    page.should have_content 'No appointments'

    click_on 'Back to admin'
    page.should have_css '.navbar-brand', text: 'Manage users'
  end
end
