require 'spec_helper'

feature 'details page for upcoming job' do
  let!(:job) { create :job, :assigned, :with_service, :with_repair, :with_discount, mechanic: mechanic }
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
      should have_content 'Appointment'
      should have_content job.scheduled_at.to_s(:time_day_month)

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

      job.tasks.each_with_index do |task, i|
        row = "#{task.title} #{number_to_currency task.cost}"
        row = "Service #{row}" if i == 0
        should have_css "tr", row
      end

      should have_css "tr", "Discount #{number_to_currency job.discount_amount}"
      should have_css "tr", "Total Fees #{number_to_currency job.final_cost}"
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
end
