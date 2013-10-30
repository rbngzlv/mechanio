require 'spec_helper'

feature 'Appointments' do
  let(:user)        { create :user }
  let!(:mechanic)   { create :mechanic }
  let!(:job)        { create :job_with_service, :estimated, user: user }
  let(:tomorrow)    { DateTime.now.tomorrow.day }

  subject { page }

  before do
    login_user user
    reset_mail_deliveries
  end

  specify 'navigation' do
    visit users_estimates_path
    click_link 'Book Appointments'
    current_path.should be_eql edit_users_appointment_path(job)
  end

  it 'booking - lists mechanics and shows mechanic popup', :js do
    visit edit_users_appointment_path(job)

    click_link mechanic.full_name
    should have_css "#js-mechanic-#{mechanic.id}", visible: true
  end

  it 'selects a mechanic' do
    visit edit_users_appointment_path(job)

    select tomorrow, from: 'job_scheduled_at_3i'
    click_button 'Book Appointment'

    should have_css 'li.active', text: 'My Appointments'
    should have_content 'Appointment booked'

    job.reload.mechanic.should eq mechanic
    job.assigned?.should be_true

    mail_deliveries.count.should eq 3
    mail_deliveries[0].tap do |m|
      m.to.should eq ['admin@example.com']
      m.subject.should eq 'Job assigned'
    end
    mail_deliveries[1].tap do |m|
      m.to.should eq [user.email]
      m.subject.should eq 'Job assigned'
    end
    mail_deliveries[2].tap do |m|
      m.to.should eq [mechanic.email]
      m.subject.should eq 'You got a new job'
    end
  end

  # TODO: realized validations of date which accessible and more than today in task: add calendar
  scenario 'fail', pending: 'we need calendar to have good ux, I dont see sance realised fails test before it' do
  end

  scenario 'cancel', pending: 'we are have not cancel button on the mockup' do
  end
end
