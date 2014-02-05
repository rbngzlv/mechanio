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

      it 'should contain comments count' do
        page.should have_selector 'span', text: "Reviews Left: #{user.reviews}"
      end

      it 'should contain default values when user is new' do
        page.should have_selector 'h4', text: user.full_name
        page.should have_content "Add some information about yourself"
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
        page.find('.user_avatar img')['src'].should match /thumb_test_img.jpg/

        should have_field 'Address', with: 'address 123'

        within('.wrap > .container') { click_link 'Dashboard' }
        should have_content description
        page.find('img.avatar')['src'].should match /thumb_test_img.jpg/
      end
    end

    scenario 'fail' do
      fill_in 'First name', with: ''
      click_button "Save"
      should have_selector '.has-error', text: 'First name'
      should have_content "can't be blank"
    end
  end

  context 'social media connections', :js do
    let!(:gmail_is_not_available) { Authentication.create provider: :google_oauth2, user: create(:user), uid: '2' }

    before { visit edit_users_profile_path(anchor: 'social-connections') }

    scenario 'manage social connections' do
      should_have_link_to_connect_with 'facebook'
      should_have_link_to_connect_with 'google_oauth2'

      click_link_to_connect_with 'facebook'
      should have_selector 'li.active', text: 'Social Media Connections'
      should have_selector '.alert-success', text: 'Facebook connection added.'
      should have_content 'Facebook connected.'
      should have_content 'user1@fb.com'
      should have_link 'Disconnect user1@fb.com'

      click_link_to_connect_with 'google_oauth2'
      should have_selector '.alert-danger', text: 'This Gmail account is already connected to another user.'

      click_link 'Disconnect user1@fb.com'
      should have_selector 'li.active', text: 'Social Media Connections'
      should have_selector '.alert-info', text: 'Facebook connection removed'
      should_have_link_to_connect_with 'facebook'
    end

    def should_have_link_to_connect_with(provider)
      should have_selector "a.#{provider}-link"
    end

    def click_link_to_connect_with(provider)
      find("a.#{provider}-link").click
    end
  end
end
