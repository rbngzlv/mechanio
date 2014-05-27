require 'spec_helper'

describe 'Email verification', :js do
  let(:user) { create :user, confirmed_at: nil }

  context 'logged in' do
    before do
      login_user user
      reset_mail_deliveries
    end

    it 'shows alert and resends verification email' do
      visit users_dashboard_path

      within '.alert' do
        page.should have_content 'Please confirm your email address'
        click_on 'Resend instructions'
      end

      page.should have_css '.nav-stacked li.active a', text: 'Dashboard'
      mail_deliveries.count.should eq 1
    end

    it 'confirms email' do
      visit user_confirmation_path(confirmation_token: user.confirmation_token)

      page.should have_css '.nav-stacked li.active a', text: 'Dashboard'
      page.should have_content 'Your email was successfully confirmed.'
      page.should_not have_content 'Please confirm your email address'
      user.reload.confirmed_at.should_not be_nil
    end
  end

  context 'logged out' do
    it 'confirms email' do
      visit user_confirmation_path(confirmation_token: user.confirmation_token)

      page.should have_css '.nav-stacked li.active a', text: 'Dashboard'
      page.should have_content 'Your email was successfully confirmed.'
      page.should_not have_content 'Please confirm your email address'
      user.reload.confirmed_at.should_not be_nil
    end
  end
end
