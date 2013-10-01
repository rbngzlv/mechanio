require 'spec_helper'

feature 'mechanic profile page' do
  let(:mechanic) { create :mechanic }

  subject { page }

  before do
    login_mechanic mechanic

    visit mechanics_dashboard_path
  end

  scenario 'check dinamyc content' do
    click_link 'My Profile'
    should have_content mechanic.full_name
    find('img.avatar')['src'].should have_content '/images/default.jpg'
    should have_content mechanic.description
    should have_link 'Edit Profile'
  end
end
