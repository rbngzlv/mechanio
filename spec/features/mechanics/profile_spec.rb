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

  context 'should be editable' do
    before { visit edit_mechanics_profile_path }

    scenario "fail" do
      fill_in 'mechanic_first_name', with: ''
      click_button "Save"

      should have_content 'Please review the problems below'
      should have_selector '.has-error', text: "can't be blank"
    end

    context 'success' do
      scenario "upload avatar" do
        attach_file('mechanic_avatar', "#{Rails.root}/spec/features/fixtures/test_img.jpg")
        click_button 'Save'

        should have_content 'Your profile successfully updated.'
        find('.mechanic_avatar img')['src'].should have_content mechanic.reload.avatar_url :thumb
      end
    end
  end
end
