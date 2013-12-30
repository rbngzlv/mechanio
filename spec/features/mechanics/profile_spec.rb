require 'spec_helper'

feature 'mechanic profile page' do
  let(:mechanic) { create :mechanic, super_mechanic: true, qualification_verified: true }

  subject { page }

  before { login_mechanic mechanic }

  include_examples("navigation") do
    let(:role) { 'mechanics' }
  end

  context 'check content' do
    before { visit mechanics_profile_path }

    scenario 'mechanic details' do
      should have_content mechanic.full_name
      find('img.avatar')['src'].should have_content '/assets/photo.jpg'

      should have_content "#{mechanic.reviews} Review"
      should have_content mechanic.description
    end

    scenario 'check links to calenar and edit profile page' do
      click_link 'Availabilities'
      should have_selector 'h1', text: 'Calendar'

      click_link 'Back'
      click_link 'Edit Profile'
      should have_selector 'h4', text: 'Edit Profile'
      current_path.should be_eql edit_mechanics_profile_path
    end

    scenario 'check verified statuses work' do
      should have_css '.verified-icon.icon-map-marker.disabled'
      should have_css '.verified-icon.icon-phone.disabled'
      should have_css '.verified-icon:nth-child(3)'
      should_not have_css '.verified-icon:nth-child(3).disabled'
      should have_css '.verified-icon.icon-thumbs-up.disabled'
      should have_css '.verified-icon.icon-book'
      should_not have_css '.verified-icon.disabled.icon-book'
    end
  end
end
