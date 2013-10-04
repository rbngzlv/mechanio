require 'spec_helper'

feature 'mechanic profile page' do
  let(:mechanic) { create :mechanic }

  subject { page }

  before { login_mechanic mechanic }

  scenario 'check navigation' do
    visit mechanics_dashboard_path
    within('.wrap > .container') { click_link 'My Profile' }
    current_url.should eql(mechanics_profile_url)
    click_link 'Edit Profile'
    current_url.should eql(edit_mechanics_profile_url)
    click_link 'cancel'
    current_url.should eql(mechanics_profile_url)
  end

  context 'check content' do
    scenario 'mechanic details' do
      visit mechanics_profile_path
      should have_content mechanic.full_name
      find('img.avatar')['src'].should have_content '/assets/photo.jpg'
      should have_content "#{mechanic.reviews} Review"
      should have_content mechanic.description
    end
  end

  context 'should be editable' do
    before { visit edit_mechanics_profile_path }

    scenario "fail" do
      fill_in 'First name', with: ''
      click_button "Save"
      should have_selector '.has-error', text: 'First name'
      should have_content "can't be blank"
    end

    context 'success' do
      scenario "upload avatar" do
        attach_file('mechanic_avatar', "#{Rails.root}/spec/features/fixtures/test_img.jpg")
        click_button 'Save'
        should have_content 'Your profile succesfully updated.'
        find('img.avatar')['src'].should have_content mechanic.reload.avatar_url :thumb
      end
    end
  end
end
