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
      job1 = create :assigned_job, mechanic: mechanic, user: create(:user, first_name: 'Eugene'), scheduled_at: DateTime.now, tasks: [create(:repair, :with_part)]
      job2 = create :assigned_job, mechanic: mechanic, user: create(:user, first_name: 'Pavel'), scheduled_at: DateTime.tomorrow
      upcoming_jobs = [job1, job2]

      visit mechanics_jobs_path
      should have_css 'li', text: 'Upcoming Jobs'
      should have_css 'li', text: 'Completed Jobs'
      within '#scheduled-jobs' do
        upcoming_jobs.each_with_index do |job, index|
          within ".panel:nth-child(#{ index + 1 })" do
            should have_css '.panel-title', text: job.user.full_name
            within '.alert-info' do
              should have_content job.scheduled_at.to_s(:time_day_month)
              should have_content job.location.full_address
            end
            within '.panel-body > .table-responsive' do
              should have_content 'Client'
              should have_content job.user.full_name
              should have_content 'Car'
              should have_content job.car.display_title
              job.tasks.each do |task|
                should have_content task.type
                should have_content task.title
                should have_content "$#{task.cost}"
              end
              should have_content 'Total Fees'
              should have_content "$#{job.cost}"
            end
          end
        end

        first('.panel').click_link('View Details')
      end
      should have_content 'Appointment'
      current_path.should be_eql mechanics_job_path(upcoming_jobs.first)
    end

    it 'all completed jobs', :js do
      job1 = create :assigned_job, mechanic: mechanic, user: create(:user, first_name: 'Alex'), status: :completed, scheduled_at: DateTime.now
      job2 = create :assigned_job, mechanic: mechanic, user: create(:user, first_name: 'Stephan'), status: :completed, scheduled_at: DateTime.tomorrow
      completed_jobs = [job2, job1]

      visit mechanics_jobs_path
      click_link 'Completed Jobs'
      within '#past-jobs tbody' do
        completed_jobs.each_with_index do |job, index|
          within "tr:nth-child(#{ index + 1 })" do
            should have_content job.user.full_name
            should have_content job.car.display_title
            should have_content job.title
            should have_content job.cost
          end
        end

        first('tr').click_link('View Details')
      end
      should have_content 'Appointment'
      current_path.should be_eql mechanics_job_path(completed_jobs.first)
    end
  end
end
