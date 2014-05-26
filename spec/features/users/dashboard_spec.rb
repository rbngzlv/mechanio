require 'spec_helper'

feature 'dashboard page' do
  let(:user)    { create :user, authentications: [auth], first_name: 'John', last_name: 'Dow' }
  let(:rating)  { create :rating, :with_mechanic, job: job, user: user }
  let(:auth)    { create :authentication, :facebook }
  let(:job)     { create :job, :completed, :with_service, user: user }

  before do
    login_user user
    visit users_dashboard_path
  end

  it 'shows closest upcoming appointment' do
    within '.user-closest-appointment' do
      page.should have_css 'h4', text: 'Booked Appointments'
      page.should have_css 'h5', text: 'No appointments'
    end

    scheduled_time = DateTime.tomorrow + 9.hour
    closest_appointment = create :job, :assigned, :with_service, user: user, scheduled_at: scheduled_time
    another_appointment = create :job, :assigned, :with_service, user: user, scheduled_at: (scheduled_time - 1.day)
    mechanic = closest_appointment.mechanic
    visit users_dashboard_path

    within '.user-closest-appointment' do
      page.should have_css 'h4', text: 'Booked Appointments'
      page.should have_content mechanic.full_name
      page.should have_css '.reviews-row', text: '0 Reviews'
      page.should have_content mechanic.mobile_number
      page.should have_content scheduled_time.to_s(:date_time)
      page.should have_content closest_appointment.title
      page.should have_content closest_appointment.car.display_title
    end
    page.should have_no_content another_appointment.title

    click_on 'View Appointment'
    page.should have_css 'li.active', text: 'My Appointments'
  end

  it 'shows last created estimated job' do
    within '.user-last-estimated' do
      page.should have_css 'h4', text: 'My Estimates'
      page.should have_css 'h5', text: 'No estimates'
    end

    closest_estimate = create :job, :estimated, :with_service, user: user, created_at: Date.today
    another_estimate = create :job, :estimated, :with_service, user: user, created_at: Date.yesterday
    visit users_dashboard_path

    within '.user-last-estimated' do
      page.should have_css 'b.text-info', text: closest_estimate.created_at.to_s(:date_short)
      page.should have_content closest_estimate.car.display_title
      page.should have_content closest_estimate.title
      within '.alert-success' do
        page.should have_content 'Total Cost'
        page.should have_content '$350.00'
      end
    end
    page.should have_no_content another_estimate.title

    click_on 'Book Appointments'
    page.should have_css 'h4', text: 'Select a Mechanic'
  end

  context 'with review' do
    before do
      rating
      visit users_dashboard_path
    end

    it 'shows basic info' do
      page.should have_selector 'h4', text: user.full_name
      page.should have_content 'Hi, my name is John Dow'
      page.should have_content 'Left 1 Reviews'
      page.should have_css '.icon-facebook-sign'
      # page.should have_css '.verified-icons i', count: 3
    end
  end

  describe 'outstanding reviews' do
    it 'shows a message when no outstanding reviews' do
      within '.outstanding-reviews' do
        page.should have_content 'No outstanding reviews'
      end
    end

    it 'shows outstanding reviews' do
      job
      visit users_dashboard_path

      within '.outstanding-reviews' do
        page.should have_content job.title
      end
    end
  end
end
