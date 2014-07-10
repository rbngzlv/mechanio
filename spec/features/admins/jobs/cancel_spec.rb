require 'spec_helper'

describe 'Cancel job' do
  let!(:job) { create :job, :assigned, :with_service, scheduled_at: Date.yesterday }

  before do
    login_admin
  end

  it 'cancels job', :js do
    visit edit_admins_job_path(job)

    page.should have_css "h4", "#{job.title} Assigned"

    click_on 'Cancel Job'

    page.should have_css "h4", "#{job.title} Cancelled"
    page.should have_content 'Job successfully cancelled'

    page.should_not have_link 'Cancel Job'
  end
end
