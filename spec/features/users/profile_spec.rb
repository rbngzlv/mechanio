require 'spec_helper'

feature 'user profile' do
  let(:user) { create :user }

  subject { page }

  before do
    login_user
  end

  include_examples("navigation") do
    let(:role) { 'users' }
  end

  context 'view page' do
    context 'describe block show' do
      before do
        visit users_profile_path
      end

      include_examples("description block") do
        let(:reviews_count) { "Reviews Left: #{user.reviews}" }
        let(:profile) { user }
      end
    end

    it 'does show left commetns', pending: 'do it after create comment model'
    it 'does show verified statuses and socials icons', pending: 'task - user verified statuses'
  end

  context 'edit' do
    before { visit edit_users_profile_path }

    context 'success' do
      scenario "upload avatar" do
        attach_file('user_avatar', "#{Rails.root}/spec/features/fixtures/test_img.jpg")
        fill_in 'Personal description', with: (description = 'my description')

        click_button 'Save'
        should have_content 'Your profile succesfully updated.'
        find('img.avatar')['src'].should have_content user.reload.avatar_url :thumb

        within('.wrap > .container') { click_link 'Dashboard' }
        should have_content description
        find('img.avatar')['src'].should have_content user.reload.avatar_url :thumb
      end
    end

    scenario 'fail' do
      fill_in 'First name', with: ''
      click_button "Save"
      should have_selector '.has-error', text: 'First name'
      should have_content "can't be blank"
    end
  end
end
