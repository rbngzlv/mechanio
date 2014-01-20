require 'spec_helper'

feature 'mechanic edit profile page' do
  let(:mechanic) { create :mechanic }

  subject { page }

  before do
    login_mechanic mechanic
    visit edit_mechanics_profile_path
  end

  context 'edit' do
    scenario "fail" do
      fill_in 'mechanic_first_name', with: ''
      click_button "Save"

      should have_content 'Please review the problems below'
      should have_selector '.has-error', text: "can't be blank"
    end

    scenario 'success' do
      new_mechanic_name = "#{mechanic.first_name}_new_name"
      fill_in 'mechanic_first_name', with: new_mechanic_name
      click_button "Save"
      should have_selector '.alert.alert-info', text: 'Your profile successfully updated.'
    end

    scenario "upload avatar" do
      attach_file('mechanic_avatar', "#{Rails.root}/spec/features/fixtures/test_img.jpg")
      click_button 'Save'

      should have_content 'Your profile successfully updated.'
      find('img.avatar')['src'].should have_content mechanic.reload.avatar_url :thumb
    end
  end

  scenario 'check content' do
    should have_selector 'select:nth-child(1)#mechanic_dob_3i'
    should have_selector 'select:nth-child(2)#mechanic_dob_2i'
    should have_selector 'select:nth-child(3)#mechanic_dob_1i'

    should have_selector 'label', text: 'Driver License Number'

    should have_selector 'input[type=text]#mechanic_years_as_a_mechanic'

    click_link 'Availabilities'
    should have_selector 'h1', text: 'Calendar'
  end
end
