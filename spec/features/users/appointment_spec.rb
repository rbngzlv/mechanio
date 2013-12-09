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
    click_link 'Book Appointment'
    current_path.should be_eql edit_users_appointment_path(job)
  end

  it 'booking - lists mechanics and shows mechanic popup', :js do
    visit edit_users_appointment_path(job)

    click_link mechanic.full_name
    should have_css "#js-mechanic-#{mechanic.id}", visible: true
  end

  context 'selects a mechanic through schedule' do
    before { visit edit_users_appointment_path(job) }

    scenario 'check calendar', :js do
      find('tbody tr:nth-of-type(5) td.fc-widget-content').click
      expected_datetime = Date.today + 3.day + 17.hour
      find('#job_scheduled_at', visible: false)[:value].should include expected_datetime.strftime('%b %d %Y %T GMT+0000')
    end

    scenario 'choose unavailable slot' do
      click_button 'Book Appointment'
      should have_selector('.alert.alert-danger', text: 'Choose time slot(s) please.')
    end

    scenario 'choose unavailable slot' do
      create :event, mechanic: mechanic, date_start: Date.tomorrow
      find('#job_scheduled_at').set(scheduled_at = Date.tomorrow + 9.hour)
      click_button 'Book Appointment'
      should have_content("This mechanic is unavailable in #{scheduled_at}")
    end

    scenario 'choose previous perioud' do
      find('#job_scheduled_at').set(Date.yesterday + 9.hour)
      click_button 'Book Appointment'
      should have_content('You could not check time slot in the past')
    end

    scenario 'success' do
      create :event, mechanic: mechanic, date_start: Date.tomorrow + 3.day
      event_date_start = Date.tomorrow
      event_time_start = event_date_start + 9.hour
      find('#job_scheduled_at').set(event_time_start)
      click_button 'Book Appointment'

      should have_css 'li.active', text: 'My Appointments'
      should have_content 'Appointment booked'

      job.reload.mechanic.should eq mechanic
      job.assigned?.should be_true

      event = mechanic.events.last
      event.date_start.should be_eql event_date_start
      (event.date_start + event.time_start.hour.hour).should be_eql event_time_start
      (event.date_start + event.time_end.hour.hour).should be_eql event_time_start + 2.hour

      mail_deliveries.count.should eq 3
      mail_deliveries[0].tap do |m|
        m.to.should eq ['admin@example.com']
        m.subject.should eq 'Job assigned'
      end
      mail_deliveries[1].tap do |m|
        m.to.should eq [user.email]
        m.subject.should eq 'Your booking with Mechanio is confirmed'
      end
      mail_deliveries[2].tap do |m|
        m.to.should eq [mechanic.email]
        m.subject.should eq 'Congratulations, you’ve been scheduled a job.'
      end
    end
  end

  specify 'ordering mechanic by distance' do
    mechanic2 = create :mechanic, location: create(:location, latitude: 40.000000, longitude: -77.000000)
    mechanic3 = create :mechanic, location: create(:location, latitude: 39.100000, longitude: -76.100000)
    mechanic.location = create(:location, latitude: 38.000000, longitude: -75.000000)
    mechanic.save
    visit edit_users_appointment_path(job)
    within 'section' do

      should have_selector('> :nth-child(5) h5', text: mechanic.full_name)
      should have_selector('> :nth-child(7) h5', text: mechanic3.full_name)
      should have_selector('> :nth-child(9) h5', text: mechanic2.full_name)
    end
  end

  specify 'show error when no mechanics found' do
    job_without_location = create(:job_with_service, :estimated, user: user, location: create(:location, postcode: '9999'))
    visit edit_users_appointment_path(job_without_location)
    should have_content 'Sorry, we could not find any mechanics near you'
  end

  scenario 'cancel', pending: 'we are have not cancel button on the mockup' do
  end
end
