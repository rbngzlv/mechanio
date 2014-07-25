require 'spec_helper'

describe 'Complete job' do
  let!(:job) { create :job, :assigned, :with_service, scheduled_at: Date.yesterday }

  before do
    login_admin
  end

  it 'completes job', :js do
    visit edit_admins_job_path(job)

    page.should have_css "h4", "#{job.title} Assigned"

    click_on 'Complete Job'

    page.should have_css "h4", "#{job.title} Completed"
    page.should have_content 'Job successfully completed'

    page.should_not have_link 'Complete Job'
  end

  describe 'process payment after job is completed', :vcr do
    let(:successful_card)   { { number: '4111 1111 1111 1111', cvv: '123', expiration_month: '11', expiration_year: '2008' } }

    before do
      Resque.inline = true
      visit edit_admins_job_path(job)
    end

    after do
      Resque.inline = false
    end

    it 'sets job status to "charged" on success', :js do
      Payments::VerifyCard.new.call(job.user, job, successful_card)

      click_on 'Complete Job'
      page.should have_css "h4", "#{job.title} Charged"
    end

    it 'sets job status to "charge_failed" on error', :js do
      click_on 'Complete Job'
      page.should have_css "h4", "#{job.title} Charge failed"
    end
  end
end
