require 'spec_helper'

feature 'dashboard page' do
  let(:mechanic) { create :mechanic, description: nil }

  subject { page }

  before do
    login_mechanic mechanic
    visit mechanics_dashboard_path
  end

  context 'should have dynamic content' do
    include_examples("description block") do
      let(:reviews_count) { "#{mechanic.reviews} Reviews" }
      let(:profile) { mechanic }
    end
  end

  context 'jobs' do
    scenario 'upcoming jobs' do
      job = create :job_with_service, mechanic: mechanic, status: :assigned
      visit mechanics_dashboard_path
      within '.col-md-9 > .row:nth-child(2)' do
        should have_selector '.panel-title', text: 'Upcoming Jobs'
        should have_content "#{job.user.full_name}"
        should have_content "#{job.date.to_formatted_s(:job_date_mechanic)}"
      end
    end

    scenario 'completed jobs' do
      job = create :job_with_service, mechanic: mechanic, status: :completed
      visit mechanics_dashboard_path
      within '.col-md-9 > .row:nth-child(3)' do
        should have_selector '.panel-title', text: 'Completed Jobs'
        should have_content "#{job.user.full_name}"
        should have_content "#{job.date.to_formatted_s(:job_date_mechanic)}"
      end
    end
  end
end
