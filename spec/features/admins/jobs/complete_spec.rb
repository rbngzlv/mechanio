require 'spec_helper'

describe 'Complete job' do
  let!(:job) { create :job, :assigned, :with_service, scheduled_at: Date.yesterday }

  before do
    login_admin
  end

  it 'reassigns job', :js do
    visit edit_admins_job_path(job)

    page.should have_css "h4", "#{job.title} Assigned"

    click_on 'Complete Job'

    page.should have_css "h4", "#{job.title} Completed"
    page.should have_content 'Job successfully completed'

    page.should_not have_link 'Complete Job'
  end
end
