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


  context 'book appointment', :js do
    before { visit edit_users_appointment_path(job) }

    it 'shows mechanic popup' do
      click_link mechanic.full_name
      should have_css "#js-mechanic-#{mechanic.id}", visible: true
    end

    scenario 'success' do
      select_date
      click_button 'Book Appointment'

      should have_content 'Appointment booked'
      should have_content 'Payment Process'

      job.reload.mechanic.should eq mechanic
      job.assigned?.should be_true
      mechanic.events.count.should eq 1
      mail_deliveries.count.should eq 3
    end

    def select_date
      find('.fc-agenda-slots tr:nth-of-type(5) td.fc-widget-content').click
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
