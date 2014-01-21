require 'spec_helper'

feature 'dashboard page' do
  let(:mechanic) { create :mechanic, description: nil }
  let(:reviews_block_content) { "#{mechanic.reviews} Reviews" }

  subject { page }

  before do
    login_mechanic mechanic
    visit mechanics_dashboard_path
  end

  context 'should have dynamic content' do
    specify 'comments count' do
      page.should have_selector 'span', text: reviews_block_content
    end

    specify 'default values when user is new' do
      page.should have_selector 'h4', text: mechanic.full_name
      page.should have_link 'Add some information about yourself', href: edit_mechanics_profile_path
    end
  end

  context 'jobs' do
    specify 'notify about empty job list' do
      should have_content 'No Upcoming Jobs'
      should have_content 'No Completed Jobs'
    end

    scenario 'upcoming jobs' do
      job = create :assigned_job, mechanic: mechanic
      visit mechanics_dashboard_path
      within '.col-md-9 > .row:nth-child(2)' do
        should have_selector '.panel-title', text: 'Upcoming Jobs'
        should have_content "#{job.user.full_name}"
        should have_content "#{job.scheduled_at.to_s(:date_time)}"
      end
    end

    scenario 'completed jobs' do
      job = create :assigned_job, mechanic: mechanic, status: :completed
      visit mechanics_dashboard_path
      within '.col-md-9 > .row:nth-child(3)' do
        should have_selector '.panel-title', text: 'Completed Jobs'
        should have_content "#{job.user.full_name}"
        should have_content "#{job.scheduled_at.to_s(:date_time)}"
      end
    end
  end

  specify 'N review should be link to profile' do
    visit mechanics_dashboard_path
    click_link reviews_block_content
    should have_selector 'li.active', text: 'My Profile'
  end

  context 'edit avatar by clicking on the profile picture' do
    specify 'form can upload photo' do
      image_path = "#{Rails.root}/spec/features/fixtures/test_img.jpg"
      visit mechanics_dashboard_path
      attach_file('mechanic_avatar', image_path)
      expect {
        click_button 'Save'
      }.to change { mechanic.reload.avatar? }.from(false).to(true)
    end

    specify 'form should be hidden' do
      should have_selector '#mechanic_avatar', visible: false
      should have_selector 'input[type=submit]', visible: false
    end
  end
end
