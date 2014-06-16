require 'spec_helper'

feature 'user profile' do
  let(:user)    { create :user, authentications: [auth], first_name: 'John', last_name: 'Dow' }
  let(:auth)    { create :authentication, :gmail }
  let(:job)     { create :job, :completed, :with_service }
  let(:rating)  { create :rating, job: job, user: user, mechanic: job.mechanic }
  let!(:suburb) { create :sydney_suburb }

  before do
    login_user user
  end

  include_examples('navigation') do
    let(:role) { 'users' }
  end

  context 'view page' do
    before do
      rating
      visit users_profile_path
    end

    specify 'shows basic info' do
      page.should have_content 'Left 1 Reviews'
      page.should have_content 'Hi, my name is John Dow'
      # page.should have_css '.verified-icons i', count: 3
      page.should have_css '.social .icon-google-plus-sign'
    end

    specify 'shows ratings' do
      page.should have_css 'h5', text: 'Reviews Left'

      within '.review-block' do
        page.should have_content 'John Dow'
        page.should have_content job.car.display_title

        within '.rating' do
          page.should have_css '.full-star', count: 3
        end
      end
    end
  end

  context 'edit' do
    before { visit edit_users_profile_path }

    scenario 'edit location information with suburb autocomplete', :js do
      fill_in 'Address', with: 'address 123'
      fill_in 'Suburb', with: 'Sydney'
      # find('.tt-dropdown-menu p', text: 'Sydney').click

      click_button 'Save'

      page.should have_content 'Your profile successfully updated.'
      page.should have_field 'Address', with: 'address 123'
      page.should have_field 'Suburb', with: 'Sydney'
    end

    scenario 'unexisting suburb is ignored', :js do
      fill_in 'Suburb', with: 'Unexisting'

      click_button 'Save'

      page.should have_content 'Your profile successfully updated.'
      page.should have_field 'Suburb', with: ''
    end

    scenario 'upload avatar' do
      attach_file('user_avatar', "#{Rails.root}/spec/fixtures/test_img.jpg")
      click_button 'Save'

      page.should have_content 'Your profile successfully updated.'
      page.find('.user_avatar img')['src'].should match /thumb_test_img.jpg/

      within('.wrap > .container') { click_link 'Dashboard' }
      page.find('img.avatar')['src'].should match /thumb_test_img.jpg/
    end

    scenario 'fail' do
      fill_in 'First name', with: ''
      click_button "Save"
      page.should have_selector '.has-error', text: 'First name'
      page.should have_content "can't be blank"
    end
  end

  context 'social media connections', :js do
    before do
      create :authentication, provider: :google_oauth2, user: create(:user), uid: 2
      visit edit_users_profile_path(anchor: 'social-connections')
    end

    scenario 'manage social connections' do
      page.should have_content 'Facebook not connected'
      within('.facebook') { click_link 'Connect' }
      page.should have_content 'Facebook connection added.'
      page.should have_content 'Facebook connected'

      page.should have_content 'Gmail connected'
      within('.google_oauth2') { click_link 'Disconnect' }
      page.should have_content 'Gmail connection removed'
      page.should have_content 'Gmail not connected'
    end
  end
end
