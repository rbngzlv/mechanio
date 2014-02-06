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
    before do
      visit users_profile_path
    end

    context 'describe block' do
      it 'should contain comments count' do
        page.should have_selector 'span', text: "Reviews Left: #{user.reviews}"
      end

      it 'should contain default values when user is new' do
        page.should have_selector 'h4', text: user.full_name
        page.should have_content "Add some information about yourself"
      end
    end

    it 'does show left commetns', pending: 'do it after create comment model'

    it 'does show verified statuses' do
      within '.verified-icons' do
        all('i').length.should be 3
      end
    end

    it 'does show and socials icons' do
      user.authentications << create(:authentication, :gmail)
      visit users_profile_path
      within '.user-panel-body .social' do
        page.should have_no_selector 'i.icon-facebook-sign'
        page.should have_selector 'i.icon-google-plus-sign'
      end
    end
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
    before do
      create :authentication, provider: :google_oauth2, user: create(:user), uid: 2
      visit edit_users_profile_path(anchor: 'social-connections')
    end

    scenario 'manage social connections' do
      within '.facebook' do
        should have_css 'td', text: 'Facebook not connected'
        click_link 'Connect'
      end
      should have_css '.alert-success', text: 'Facebook connection added.'

      within '.facebook' do
        should have_css 'td', text: 'Facebook connected'
        click_link 'Disconnect'
        should have_css 'td', text: 'Facebook not connected'
      end
      should have_css '.alert-info', text: 'Facebook connection removed'

      within '.google_oauth2' do
        should have_css 'td', text: 'Gmail not connected'

        click_link 'Connect'
        should have_css 'td', text: 'Gmail not connected'
      end
      should have_css '.alert-danger', text: 'This Gmail account is already connected to another user.'
    end
  end
end
