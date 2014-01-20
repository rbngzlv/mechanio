require 'spec_helper'

feature 'mechanic edit profile page' do
  let(:mechanic) { create :mechanic, first_name: 'Bob' }

  subject { page }

  before do
    login_mechanic mechanic
    visit edit_mechanics_profile_path
  end

  context 'edit' do
    scenario "fail" do
      fill_in 'mechanic_first_name', with: ''
      click_button 'Save'

      should have_content 'Please review the problems below'
      should have_selector '.has-error', text: "can't be blank"
    end

    scenario 'success' do
      fill_in 'First name', with: 'Alex'
      click_button 'Save'

      should have_selector '.alert.alert-info', text: 'Your profile successfully updated.'
    end

    scenario 'upload avatar' do
      attach_file('mechanic_avatar', "#{Rails.root}/spec/features/fixtures/test_img.jpg")
      click_button 'Save'

      should have_content 'Your profile successfully updated.'
      find('.mechanic_avatar img')['src'].should have_content mechanic.reload.avatar_url :thumb
    end
  end
end
