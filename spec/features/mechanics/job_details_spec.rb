require 'spec_helper'

feature 'dashboard page' do
  let(:mechanic) { create :mechanic }
  let!(:job) { create :assigned_job, mechanic: mechanic }

  subject { page }

  before { login_mechanic mechanic }

  specify 'dashboard should have link to job details' do
    visit mechanics_dashboard_path
    click_link 'View Details'
    should have_content 'Appointment'
  end

  specify 'my jobs page should have link to job details', pending: 'my jobs page is not reliased' do
  end

  it 'should' do
    visit mechanics_job_path(job)
    within '.panel' do
      should have_link 'Back to My jobs'
      should have_content 'Appointment'
      should have_content job.scheduled_at.to_s(:date)
      should have_content job.car.display_title
      job.tasks.each do |task|
        should have_content task.type
        should have_content task.title
        should have_content task.cost
      end
      should have_content job.cost
      should have_link 'Cancel Job'
      should have_link 'Edit Job'
      should have_link 'Save'
    end
  end

  specify 'mechanic have access only for his own jobs' do
    another_job = create :job_with_service, status: 'assigned', mechanic: create(:mechanic, email: 'qw@qw.qw')
    expect { visit mechanics_job_path(another_job) }.to raise_error
    visit mechanics_job_path(job)
    should have_no_selector 'li.active', text: 'Dashboard'
  end
end
