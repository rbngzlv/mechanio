require 'spec_helper'

feature 'details page for upcoming job' do
  let!(:job) { create :job, :with_repair, :assigned, mechanic: mechanic }
  let(:mechanic) { create :mechanic }

  subject { page }

  before { login_mechanic mechanic }

  specify 'dashboard should have link to upcoming job details' do
    visit mechanics_dashboard_path
    click_link 'View Details'
    should have_content 'Appointment'
  end

  specify 'my jobs page should have link to upcoming job details' do
    visit mechanics_jobs_path
    click_link 'View Details'
    should have_content 'Appointment'
  end

  it 'should have "back" link to jobs list' do
    visit mechanics_job_path(job)
    click_link 'Back to My jobs'
    should have_selector('li.active', text: 'My Jobs')
    current_path.should be_eql mechanics_jobs_path
  end

  it 'should show job details' do
    visit mechanics_job_path(job)
    within '.panel' do
      should have_content 'Client'
      should have_content job.client_name
      should have_content job.location.full_address
      should have_content job.contact_phone
      should have_content 'Car'
      should have_content job.car.display_title
      should have_content 'VIN'
      should have_field 'car_vin'
      should have_content 'Registration Number'
      should have_field 'car_reg_number'
      should have_content 'Appointment'
      should have_content job.scheduled_at.to_s(:time_day_month)
      job.tasks.each do |task|
        should have_content task.type
        should have_content task.title
        should have_content "$#{task.cost}"
      end
      should have_content "$#{job.cost}"
    end
  end

  context 'has ability to add VIN and Car Registration Number' do
    before { visit mechanics_job_path(job) }

    context 'add VIN' do
      scenario 'success' do
        fill_in 'car_vin', with: '12345678901234567'
        within('.edit_vin') { click_button 'Save' }
        should have_selector '.alert-info', text: 'Car details successfully updated'
        should have_field 'car_vin', with: '12345678901234567'
      end
    end

    scenario 'add Car Registration Number' do
      fill_in 'car_reg_number', with: 'something'
      within('.edit_reg_number') { click_button 'Save' }
      should have_selector '.alert-info', text: 'Car details successfully updated'
      should have_field 'car_reg_number', with: 'something'
    end
  end

  specify 'complete job' do
    visit mechanics_jobs_path

    click_on 'View Details'
    click_on 'Complete job'

    page.should have_content job.uid
    page.should have_link 'View Receipt'
  end
end
