require 'spec_helper'

feature 'new appointment', :js do
  let(:user)       { create :user }
  let(:job)        { create :job_with_service, :estimated, user: user, location: create(:location, postcode: postcode) }
  let(:mechanic)   { create :mechanic, mechanic_regions: [create(:mechanic_region, postcode: postcode)], years_as_a_mechanic: 2 }
  let(:location)   { create :location, postcode: postcode }
  let(:postcode)   { '1234' }
  let(:tomorrow)   { Date.tomorrow.in_time_zone }
  let(:timeslot)   { tomorrow.advance(days: 3, hours: 9) }

  before do
    login_user user
    reset_mail_deliveries
  end

  scenario 'book appointment', :vcr do
    mechanic
    job

    visit users_estimates_path
    click_link 'Book Appointment'

    find('.profile-border.clickable').click
    page.should have_css "#js-mechanic-#{mechanic.id}", visible: true
    find('.close').click

    click_timeslot
    click_button 'Book Appointment'

    page.should have_css 'h4', text: 'Payment Process'
    verify_job_details
    verify_mechanic_popup

    job_is_appointment? false

    fill_in_cc 'cardholder_name', 'Don Joe'
    fill_in_cc 'number', '4111 1111 1111 1111'
    fill_in_cc 'expiration_month', '11'
    fill_in_cc 'expiration_year', '08'
    fill_in_cc 'cvv', '123'
    click_button "Book #{mechanic.first_name} for " + timeslot.to_s(:date_abr)

    page.should have_css '.alert-info', text: 'Appointment booked'
    page.should have_css '.aside li.active a', text: 'My Appointments'
    page.should have_css '.nav-tabs li.active a', text: 'Current Appointments'
    page.should have_content mechanic.full_name

    job_is_appointment? true
    emails_sent? true
  end

  scenario 'calendar navigation' do
    mechanic
    mechanic2 = create :mechanic, mechanic_regions: [create(:mechanic_region, postcode: '1234')]

    visit edit_users_appointment_path(job)

    within_calendar(1) do
      submit_enabled?(false)
      prev_enabled?(false)
      calendar_starts_at?(tomorrow)

      click_timeslot
      submit_enabled?(true)

      click_next
      prev_enabled?(true)
      calendar_starts_at?(tomorrow + 7.days)
    end

    within_calendar(2) do
      submit_enabled?(false)
      prev_enabled?(false)
      calendar_starts_at?(tomorrow)
    end

    within_calendar(1) do
      click_prev
      prev_enabled?(false)
      calendar_starts_at?(tomorrow)
    end
  end

  specify 'ordering mechanic by distance' do
    pending 'Geocoding is not used for now, as we switched to matching mechanics by region'

    mechanic2 = create :mechanic, location: create(:location, latitude: 40.000000, longitude: -77.000000)
    mechanic3 = create :mechanic, location: create(:location, latitude: 39.100000, longitude: -76.100000)

    visit edit_users_appointment_path(job)
    within 'section' do

      should have_selector('> :nth-child(5) h5', text: mechanic.full_name)
      should have_selector('> :nth-child(7) h5', text: mechanic3.full_name)
      should have_selector('> :nth-child(9) h5', text: mechanic2.full_name)
    end
  end

  specify 'only lists active mechanics' do
    mechanic
    suspended_mechanic = create :mechanic, :suspended, mechanic_regions: [create(:mechanic_region, postcode: postcode)], location: create(:location, postcode: postcode)

    visit edit_users_appointment_path(job)

    page.should have_content mechanic.full_name
    page.should_not have_content suspended_mechanic.full_name
  end

  specify 'show error when no mechanics found', :js do
    mechanic
    job_without_location = create(:job_with_service, :estimated, user: user, location: create(:location, postcode: '9999'))

    visit edit_users_appointment_path(job_without_location)

    page.should have_content 'Sorry, we could not find any mechanics near you'
  end

  def within_calendar(i, &block)
    within ".mechanics .panel:nth-of-type(#{i}) .calendar-container" do
      block.call
    end
  end

  def calendar_starts_at?(date)
    page.should have_css '.fc-agenda-axis + th', text: date.strftime('%a %-m/%-d')
  end

  def submit_enabled?(enabled)
    find_button('Book Appointment', disabled: !enabled).should_not be_nil
  end

  def prev_enabled?(yes)
    if yes
      page.should have_css('.left-arrow')
      page.should have_no_css('.left-arrow.disabled')
    else
      page.should have_css('.left-arrow.disabled')
    end
  end

  def click_prev
    find('.left-arrow').click
  end

  def click_next
    find('.right-arrow').click
  end

  def click_timeslot
    first('.fc-agenda-slots td.fc-widget-content').click
    find('#job_scheduled_at', visible: false)[:value].should == timeslot.to_s(:js)
  end

  def job_is_appointment?(yes)
    if yes
      job.reload.mechanic.should eq mechanic
      job.assigned?.should be_true
      mechanic.events.count.should eq 1
    else
      job.reload.mechanic.should be_nil
      job.assigned?.should be_false
      mechanic.events.count.should eq 0
    end
  end

  def emails_sent?(yes = true)
    mail_deliveries.count.should eq 3 if yes
  end

  def fill_in_cc(name, value)
    find("*[data-encrypted-name=credit_card\\[#{name}\\]]").set(value)
  end

  def verify_job_details
    page.should have_css 'h4', text: job.title
    page.should have_content mechanic.full_name
    page.should have_content '2 years of experience'
    page.should have_content timeslot.to_s(:date_time)
    page.should have_content job.car.display_title
    page.should have_content job.location.full_address

    page.should have_css 'h4', text: 'Price Breakdown'
    page.should have_content job.tasks.first.title
    page.should have_content job.cost
    # page.should have_link 'Redeem promo code'
    page.should have_content 'You pay $0 to secure this booking.'
    page.should have_content 'You pay after the job is done.'
  end

  def verify_mechanic_popup
    find('.profile-border.clickable').click
    page.should have_css "#js-mechanic-#{mechanic.id}", visible: true
    within "#js-mechanic-#{mechanic.id}" do
      find('button.close').click
    end
  end
end
