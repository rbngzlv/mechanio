require 'spec_helper'

feature 'mechanic "my jobs" page' do
  let(:mechanic) { create :mechanic}

  subject { page }

  before { login_mechanic mechanic}

  specify 'dashboard should have link to "my jobs" page' do
    visit mechanics_dashboard_path
    within('.nav-stacked') { click_link 'My Jobs' }
    should have_content 'Upcoming Jobs'
    current_path.should be_eql mechanics_jobs_path
  end

  it 'should show messages about exepted completed/upcoming jobs', :js do
    visit mechanics_jobs_path
    should have_content 'You have no upcoming jobs'
    click_link 'Completed Jobs'
    should have_content 'You have no completed jobs'
  end

  context 'should contain general information about' do
    it 'all upcoming jobs' do
      job1 = create :job, :assigned, :with_repair, mechanic: mechanic, scheduled_at: DateTime.now
      job2 = create :job, :assigned, :with_service, mechanic: mechanic, scheduled_at: DateTime.tomorrow
      job3 = create :job, :assigned, :with_service, :with_discount, mechanic: mechanic, scheduled_at: DateTime.tomorrow.advance(days: 1)
      upcoming_jobs = [job3, job2, job1]

      visit mechanics_jobs_path

      should have_css 'li', text: 'Upcoming Jobs'
      should have_css 'li', text: 'Completed Jobs'

      within '#scheduled-jobs' do
        upcoming_jobs.each_with_index do |job, index|
          within ".panel:nth-child(#{ index + 1 })" do
            should have_css '.panel-title', text: job.client_name

            within '.alert-info' do
              should have_content job.scheduled_at.to_s(:time_day_month)
              should have_content job.location.full_address
            end

            within '.panel-body > .table-responsive' do
              should have_css "tr", text: "Car: #{job.car.display_title}"
              job.tasks.each_with_index do |task, i|
                row = "#{task.title} #{number_to_currency task.cost}"
                row = "Service: #{row}" if i == 0
                should have_css "tr", text: row
              end
              should have_css "tr", text: "20% off discount #{number_to_currency job.discount_amount}" if job.discount.present?
              should have_css "tr", text: "Total Fees #{number_to_currency job.final_cost}"
            end
          end
        end

        first('.panel').click_link('View Details')
      end
      should have_content 'Appointment'
      current_path.should be_eql mechanics_job_path(upcoming_jobs.first)
    end

    it 'all completed jobs', :js do
      job1 = create :job, :completed, :with_service, mechanic: mechanic, scheduled_at: DateTime.now, assigned_at: Date.yesterday
      job2 = create :job, :completed, :with_repair, mechanic: mechanic, scheduled_at: DateTime.tomorrow, assigned_at: Date.yesterday
      job3 = create :job, :completed, :with_service, :with_discount, mechanic: mechanic, scheduled_at: DateTime.tomorrow + 1.day, assigned_at: Date.yesterday + 1.day
      completed_jobs = [job3, job2, job1]

      visit mechanics_jobs_path
      click_link 'Completed Jobs'

      within '#past-jobs thead' do
        should have_css 'tr', text: 'Client Name Car Services Total Cost Option'
      end

      within '#past-jobs tbody' do
        completed_jobs.each_with_index do |job, index|
          should have_css "tr:nth-child(#{ index + 1 })", "#{job.client_name} #{job.car.display_title} #{job.title} #{job.final_cost}"
        end
      end
    end
  end
end
