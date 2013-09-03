require 'spec_helper'

describe 'Admin user management' do

  let!(:user) { create :user }

  before do
    login_admin
  end

  it 'navigates through users section' do
    visit admin_dashboard_path
    click_link 'Users'

    page.should have_css 'h4', text: 'Manage users'
    page.should have_css 'td', text: user.full_name
    click_link 'Details'

    page.should have_css 'h4', text: 'User details'
    page.should have_css 'dd', text: user.full_name
  end

  it 'lists available users' do
    visit admin_users_path

    page.should have_css 'td', text: user.full_name
  end

  it 'shows user details' do
    visit admin_user_path(user)

    page.should have_css 'h4', text: 'User details'
    page.should have_css 'dd', text: user.full_name
  end

  it 'deletes a user' do
    expect do
      visit admin_user_path(user)
      click_link 'Delete'
    end.to change { User.count }.by -1

    page.should have_css '.alert', text: 'User succesfully deleted.'
  end
end
