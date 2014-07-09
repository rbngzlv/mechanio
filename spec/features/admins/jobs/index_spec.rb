require 'spec_helper'

feature 'Jobs index' do
  before { login_admin }

  it 'is accessible from admin dashboard' do
    visit admins_dashboard_path

    click_link 'Jobs'

    current_path.should be_eql(admins_jobs_path)
  end

  context 'filter jobs' do
    specify 'filters by status', :js do
      pending        = create :job, :pending, :with_service
      estimated      = create :job, :estimated, :with_service
      assigned       = create :job, :assigned, :with_service
      completed      = create :job, :completed, :with_service
      charged        = create :job, :charged, :with_service
      charge_failed  = create :job, :charge_failed, :with_service
      paid_out       = create :job, :paid_out, :with_service
      rated          = create :job, :rated, :with_service
      cancelled      = create :job, :cancelled, :with_service

      visit admins_jobs_path

      page.should have_css 'thead tr', text: 'ID Status Job Requested by Allocated to Location Cost'

      verify_job_row(cancelled, 1)
      verify_job_row(rated, 2)
      verify_job_row(paid_out, 3)
      verify_job_row(charge_failed, 4)
      verify_job_row(charged, 5)
      verify_job_row(completed, 6)
      verify_job_row(assigned, 7)
      verify_job_row(estimated, 8)
      verify_job_row(pending, 9)

      filter_by('Pending')
      verify_has_jobs(1)
      verify_job_row(pending, 1)

      filter_by('Estimated')
      verify_has_jobs(1)
      verify_job_row(estimated, 1)

      filter_by('Assigned')
      verify_has_jobs(1)
      verify_job_row(assigned, 1)

      filter_by('Completed')
      verify_has_jobs(2)
      verify_job_row(rated, 1)
      verify_job_row(completed, 2)

      filter_by('Charged')
      verify_has_jobs(1)
      verify_job_row(charged, 1)

      filter_by('Charge failed')
      verify_has_jobs(1)
      verify_job_row(charge_failed, 1)

      filter_by('Paid out')
      verify_has_jobs(1)
      verify_job_row(paid_out, 1)

      filter_by('Rated')
      verify_has_jobs(1)
      verify_job_row(rated, 1)

      filter_by('Cancelled')
      verify_has_jobs(1)
      verify_job_row(cancelled, 1)
    end

    specify 'searches job by keywords' do
      job = create :job, :estimated, :with_service
      keyword = job.uid[0..5]

      visit admins_jobs_path

      fill_in 'Search keywords', with: keyword
      click_on 'Search'

      verify_has_jobs(1)
      verify_job_row(job, 1)

      page.should have_field 'Search keywords', with: keyword
    end
  end

  def verify_job_row(job, row_count)
    within "tbody tr:nth-child(#{row_count})" do
      page.should have_css 'td', text: job.uid
      page.should have_css 'td', text: job.status.humanize
      page.should have_css 'td', text: job.location.suburb_name
      page.should have_css 'td', text: job.title
      page.should have_css 'td', text: job.created_at.to_s(:date)
      page.should have_css 'td', text: job.client_name
      page.should have_css 'td', text: job.scheduled_at? ? job.scheduled_at.to_s(:date_time) : ''
      page.should have_css 'td', text: job.mechanic ? job.mechanic.full_name : 'unassigned'
      page.should have_css 'td', text: job.final_cost
      page.should have_link 'Edit'
    end
  end

  def filter_by(status)
    select status, from: 'status'
    click_on 'Search'
  end

  def verify_has_jobs(count)
    page.should have_css 'tbody tr', count: count
  end
end
