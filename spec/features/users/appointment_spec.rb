require 'spec_helper'

feature 'appointment page' do
  let(:user) { create :user }
  let!(:job) { create :job_with_service, status: 'estimated', user: user }

  subject { page }

  before do
    login_user user
  end

  specify 'navigation' do
    visit users_estimates_path
    click_link 'Book Appointments'
    current_path.should be_eql edit_users_appointment_path(job)
  end

  context 'process' do
    let!(:mechanic) { create :mechanic }

    scenario 'check content', :js do
      visit edit_users_appointment_path(job)
      another_mechanic = create :mechanic, email: 'another@email.com'
      should have_content mechanic.full_name
      should have_content another_mechanic.full_name
      click_link mechanic.full_name
      should have_selector "#js-mechanic-#{mechanic.id}", text: mechanic.full_name
    end

    scenario 'success' do
      visit edit_users_appointment_path(job)
      day = DateTime.now.tomorrow.day
      select day, from: 'job_scheduled_at_3i'
      click_button 'Assigned'
      should have_selector 'li.active', text: 'My Appointments'
      should have_content 'Mechanic succesfully assigned.'

      # TODO: replace it by real integration test which tested same fields but through visible element. after adding
      job.reload
      job.mechanic.should == mechanic
      job.scheduled_at.day.should == day
      job.assigned_at.day.should == day - 1
      job.assigned?.should be_true
    end

    # TODO: realized validations of date which accessible and more than today in task: add calendar
    scenario 'fail', pending: 'we need calendar to have good ux, I dont see sance realised fails test before it' do
    end

    scenario 'cancel', pending: 'we are have not cancel button on the mockup' do
    end
  end
end
