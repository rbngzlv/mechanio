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
    include_examples("description block") do
      let(:reviews_count) { reviews_block_content }
      let(:profile) { mechanic }
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

  specify 'N review should be link to progile' do
    visit mechanics_dashboard_path
    click_link reviews_block_content
    should have_selector 'li.active', text: 'My Profile'
  end
end
