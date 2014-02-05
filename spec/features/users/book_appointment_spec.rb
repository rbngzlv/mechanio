require 'spec_helper'

feature 'book appointment' do
  let(:user)       { create :user }
  let(:job)        { create :job_with_service, :estimated, :with_credit_card, user: user, location: create(:location, postcode: '1234') }
  let!(:mechanic)  { create :mechanic, mechanic_regions: [create(:mechanic_region, postcode: '1234')] }
  let(:tomorrow)          { Date.tomorrow }
  let(:expected_datetime) { tomorrow + 3.day + 17.hour }

  before do
    login_user user
    reset_mail_deliveries
    visit edit_users_appointment_path(job)
  end

  scenario 'check content', :js do
    verify_calendar_start_day tomorrow
    page.should have_css '.left-arrow.disabled'

    find('.right-arrow').click
    verify_calendar_start_day tomorrow + 7.days
    find('.left-arrow').click
    verify_calendar_start_day tomorrow
    find('.left-arrow.disabled').click
    verify_calendar_start_day tomorrow

    button = find('input[type=submit]')
    button[:value].should be_eql 'Book Appointment'
    button[:disabled].should be_true

    select_time_slot
    button[:disabled].should be_false

    click_button 'Book Appointment'

    page.should have_css '.alert-info', text: 'Appointment booked'
    page.should have_css 'h4', text: job.title
    page.should have_css 'h4', text: 'Payment Process'

    job.reload.mechanic.should eq mechanic
    job.assigned?.should be_true

    mechanic.events.count.should eq 1
    mail_deliveries.count.should eq 3
  end

  scenario 'two mechanics', :js do
    mechanic2 = create :mechanic, mechanic_regions: [create(:mechanic_region, postcode: '1234')]
    visit edit_users_appointment_path(job)
    within(calendar 1) { find('.right-arrow').click }

    verify_calendar 1, start_day: tomorrow + 7.days
    verify_calendar 2, start_day: tomorrow

    within(calendar 1) { page.should have_no_css '.left-arrow.disabled' }
    within(calendar 2) { page.should have_css '.left-arrow.disabled' }
  end

  def verify_calendar_start_day(date)
    page.should have_css '.fc-agenda-axis + th', text: date.strftime('%a %-m/%-d')
  end

  def verify_calendar(calendar_number = 1, opt = {})
    date = opt[:start_day] || Date.tomorrow
    within calendar(calendar_number) do
      verify_calendar_start_day date
    end
  end

  def calendar(calendar_number)
    "section > div:nth-child(#{calendar_number * 2 + 3}) .calendar-container"
  end

  def select_time_slot
    find('.fc-agenda-slots tr:nth-of-type(5) td.fc-widget-content').click
    find('#job_scheduled_at', visible: false)[:value].should include expected_datetime.strftime('%Y-%m-%dT%H:%M')
  end
end
