require 'spec_helper'

feature 'Appointments' do
  let(:user)        { create :user }
  let!(:mechanic)   { create :mechanic }
  let!(:job)        { create :job_with_service, :estimated, user: user, location: create(:location, :with_coordinates) }
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

  it 'selects a mechanic', pending: "it'll be removed by selecting mechanic through his schedule" do
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

  context 'selects a mechanic through schedule' do
    before { visit edit_users_appointment_path(job) }

    scenario 'choose unavailable slot' do
      click_button 'Book Appointment'
      should have_selector('.alert.alert-danger', text: 'Please, choose time slot(s).')
    end

    scenario 'choose unavailable slot', :js do
      find('.unavailable').click
      click_button 'Book Appointment'
      should have_content('You could not check unavailable time slot')
    end

    scenario 'choose previous perioud', :js do
      find('.previous-week').click
      find('.available').click
      click_button 'Book Appointment'
      should have_content('You could not check time slot in the past')
    end

    scenario 'success' do
      find('#job_scheduled_at').set(Date.tomorrow + 9.hour)

      click_button 'Book Appointment'

      should have_css 'li.active', text: 'My Appointments'
      should have_content 'Appointment booked'

      job.reload.mechanic.should eq mechanic
      job.assigned?.should be_true
      event = mechanic.events.last
      event.date_start.should be_eql event_date_start
      event.time_start.should be_eql event_time_start

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
  end

  specify 'ordering mechanic by distance' do
    mechanic2 = create :mechanic, location: create(:location, :with_type, latitude: 40.000000, longitude: -77.000000)
    mechanic3 = create :mechanic, location: create(:location, :with_type, latitude: 39.100000, longitude: -76.100000)
    mechanic.location = create(:location, :with_type, latitude: 38.000000, longitude: -75.000000)
    visit edit_users_appointment_path(job)
    within 'section' do

      should have_selector('> :nth-child(5) h5', text: mechanic.full_name)
      should have_selector('> :nth-child(7) h5', text: mechanic3.full_name)
      should have_selector('> :nth-child(9) h5', text: mechanic2.full_name)
    end
  end

  specify 'job with wrong location raise error' do
    job_without_location = create(:job_with_service, :estimated, user: user)
    visit edit_users_appointment_path(job_without_location)
    should have_content 'Wrong location, we could not find your coordinates.'
  end

  # TODO: realized validations of date which accessible and more than today in task: add calendar
  scenario 'fail', pending: 'we need calendar to have good ux, I dont see sance realised fails test before it' do
  end

  scenario 'cancel', pending: 'we are have not cancel button on the mockup' do
  end
end
