require 'spec_helper'

feature 'complete a job' do
  let!(:upcoming_job) { create :job, :assigned, :with_service, mechanic: mechanic, scheduled_at: DateTime.tomorrow }
  let!(:passed_job)   { create :job, :assigned, :with_service, mechanic: mechanic, scheduled_at: DateTime.yesterday }
  let!(:mechanic)     { create :mechanic }

  before { login_mechanic mechanic }

  specify 'cannot complete upcoming job' do
    visit mechanics_job_path(upcoming_job)

    page.should_not have_link 'Complete job'
  end

  specify 'complete job', :js do
    visit mechanics_job_path(passed_job)

    click_on 'Complete job'

    page.should have_content passed_job.uid
    page.should have_content 'No feedback yet'

    passed_job.reload.completed_at.should_not be_nil
  end
end
