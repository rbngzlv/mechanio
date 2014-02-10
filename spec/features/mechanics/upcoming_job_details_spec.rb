require 'spec_helper'

feature 'details page for upcoming job' do
  let!(:job) { create :assigned_job, mechanic: mechanic, tasks: [create(:repair, :with_part)] }
  let(:mechanic) { create :mechanic }

  subject { page }

  before { login_mechanic mechanic }

  specify 'dashboard should have link to upcoming job details' do
    visit mechanics_dashboard_path
    click_link 'View Details'
    should have_content 'Appointment'
    should have_link 'Edit Job'
  end

  specify 'my jobs page should have link to upcoming job details' do
    visit mechanics_jobs_path
    click_link 'View Details'
    should have_content 'Appointment'
    should have_link 'Edit Job'
  end

  specify 'mechanic have access only for his own upcoming job' do
    another_job = create :assigned_job, mechanic: create(:mechanic, email: 'qw@qw.qw')
    expect { visit mechanics_job_path(another_job) }.to raise_error
    visit mechanics_job_path(job)
    should have_no_selector 'li.active', text: 'Dashboard'
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
      should have_content job.user.full_name
      should have_content 'Car'
      should have_content job.car.display_title
      should have_content 'VIN'
      should have_field 'car_vin'
      should have_content 'Car Registration Number'
      should have_field 'car_reg_number'
      should have_content 'Appointment'
      should have_content job.scheduled_at.to_s(:time_day_month)
      job.tasks.each do |task|
        should have_content task.type
        should have_content task.title
        should have_content "$#{task.cost}"
      end
      should have_content "$#{job.cost}"
      should have_content 'Location'
      should have_content job.location.full_address
      should have_content 'Contact'
      should have_content job.contact_phone
      should have_link 'Cancel Job'
      should have_link 'Edit Job'
      should have_link 'Save'
    end
  end

  context 'has ability to add VIN and Car Registration Number' do
    before { visit mechanics_job_path(job) }

    context 'add VIN' do
      scenario 'success' do
        fill_in 'car_vin', with: '12345678901234567'
        click_save_vin
        should have_selector '.alert-info', text: 'Car details successfully updated'
        should have_field 'car_vin', with: '12345678901234567'

        fill_in 'car_vin', with: ''
        click_save_vin
        should have_selector '.alert-info', text: 'Car details successfully updated'
        should have_field 'car_vin', with: ''
      end

      scenario 'fail' do
        fill_in 'car_vin', with: '1234567890123456'
        click_save_vin
        should have_selector 'span.help-block', text: 'VIN should be 17-digit number'

        fill_in 'car_vin', with: '17_characters_str'
        click_save_vin
        should have_selector 'span.help-block', text: 'VIN should be 17-digit number'

        fill_in 'car_vin', with: '123456789012345678'
        click_save_vin
        should have_selector 'span.help-block', text: 'VIN should be 17-digit number'
      end

      def click_save_vin
        within('.edit_vin') { click_button 'Save' }
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
