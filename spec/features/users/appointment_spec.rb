require 'spec_helper'

feature 'Appointments' do
  let(:user)        { create :user }
  let!(:mechanic)   { create :mechanic, mechanic_regions: [create(:mechanic_region, postcode: '1234')] }
  let!(:job)        { create :job_with_service, :estimated, user: user, location: location }
  let(:appointment) { create :job, :with_service, :estimated, :assigned, user: user }
  let(:location)    { create(:location, :with_coordinates, postcode: '1234') }

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

  specify 'my appointments' do
    appointment
    visit users_appointments_path

    should have_css 'li.active a', text: 'Current Appointments'
    should have_content "ID: #{appointment.uid}"
  end

  context 'check mechanic description', :js do
    specify 'book appointment page' do
      visit edit_users_appointment_path(job)
      find('.profile-border.clickable').click
      should have_css "#js-mechanic-#{mechanic.id}", visible: true
    end

    specify 'my appointment page' do
      create :assigned_job, user: user, mechanic: mechanic
      visit users_appointments_path
      find('.profile-border.clickable').click
      should have_css "#js-mechanic-#{mechanic.id}", visible: true
    end
  end

  specify 'ordering mechanic by distance' do
    pending 'Geocoding is not used for now, as we switched to matching mechanics by region'

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
