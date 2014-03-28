require 'spec_helper'

feature 'My appointments' do
  let(:user)          { create :user }
  let(:mechanic)      { create :mechanic }
  let(:current_job)   { create :job, :with_service, :estimated, :assigned, mechanic: mechanic, user: user }
  let(:completed_job) { create :job, :with_service, :completed, mechanic: mechanic, user: user }

  before do
    login_user user
    reset_mail_deliveries
  end

  specify 'current appointments', :js do
    current_job
    visit users_appointments_path

    page.should have_css 'li.active a', text: 'Current Appointments'
    page.should have_content "ID: #{current_job.uid}"

    find('.profile-border.clickable').click
    page.should have_css "#js-mechanic-#{mechanic.id}", visible: true
  end

  describe 'past appointments', :js do
    before do
      completed_job

      visit users_appointments_path

      within '.nav-tabs' do
        click_on 'Past Appointments'
      end
    end

    specify 'lists apoointments' do
      page.should have_css 'tr', text: 'Status Job Mechanic Vehicle Date Option'
      page.should have_css 'tr', text: "Completed #{completed_job.title} #{mechanic.full_name} #{completed_job.car.display_title} #{completed_job.scheduled_at.to_s(:date_short)}"
    end

    specify 'shows appointment details' do
      find('a[data-original-title="View Job"]').click

      page.should have_css 'td', text: "Total Fees"
      page.should have_content "Hi, I'm your mechanic #{completed_job.mechanic.full_name}"
      page.should have_content "LEAVE FEEDBACK"
    end
  end
end
