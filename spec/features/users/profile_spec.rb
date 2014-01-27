require 'spec_helper'

feature 'user profile' do
  let(:user) { create :user }

  subject { page }

  before do
    login_user user
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
        fill_in 'Address', with: 'address 123'

        click_button 'Save'
        should have_content 'Your profile successfully updated.'
        find('img.avatar')['src'].should have_content user.reload.avatar_url :thumb

        click_on 'Edit Profile'
        should have_field 'Address', with: 'address 123'

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

  context 'social media connections' do
    let(:authentication) { Authentication.new provider: :facebook, user: user }

    before { visit edit_users_profile_path(anchor: 'social-connections') }

    scenario 'manage social connections', :js do
      should have_selector 'a.facebook-link'
      should have_selector 'a.gmail-link'

      find('a.facebook-link').click
      should have_selector 'li.active', text: 'Social Media Connections'
      should have_selector '.alert-success', text: 'Successfully added'
      should have_no_selector 'a.facebook-link'
      should have_content 'Facebook connected.'
      should have_content 'user1@fb.com'
      should have_link 'disconnect user1@fb.com?'
      should have_selector 'a.gmail-link'

      click_link 'disconnect user1@fb.com?'
      should have_selector 'li.active', text: 'Social Media Connections'
      should have_selector '.alert-info', text: 'Connection successfully destroyed'
      should have_selector 'a.facebook-link'
    end
  end
end
