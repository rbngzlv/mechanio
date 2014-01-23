require 'spec_helper'

feature 'book appointment' do
  let(:user)       { create :user }
  let(:job)        { create :job_with_service, :estimated, :with_credit_card, user: user, location: create(:location, postcode: '1234') }
  let!(:mechanic)  { create :mechanic, mechanic_regions: [create(:mechanic_region, postcode: '1234')] }
  let(:tomorrow)          { Date.tomorrow }
  let(:expected_date)     { tomorrow + 3.day }
  let(:expected_datetime) { expected_date + 17.hour }

  before do
    login_user user
    reset_mail_deliveries
    visit edit_users_appointment_path(job)
  end

  scenario 'check content', :js do
    page.should have_css '.fc-agenda-axis + th', text: tomorrow.strftime('%a %-m/%d')
    page.should have_css '.left-arrow.disabled'

    find('.right-arrow').click
    page.should have_css '.fc-agenda-axis + th', text: (tomorrow + 7.days).strftime('%a %-m/%d')
    find('.left-arrow').click
    page.should have_css '.fc-agenda-axis + th', text: tomorrow.strftime('%a %-m/%d')
    find('.left-arrow.disabled').click
    page.should have_css '.fc-agenda-axis + th', text: tomorrow.strftime('%a %-m/%d')

    button = find('input[type=submit]')
    button[:value].should be_eql 'Book Appointment'
    button[:disabled].should be_true

    select_time_slot
    button[:disabled].should be_false

    click_button 'Book Appointment'

    page.should have_css '.alert-info', text: 'Appointment booked'
    page.should have_css 'h4', text: 'Mechanic'
    page.should have_css 'h4', text: 'Payment Process'

    job.reload.mechanic.should eq mechanic
    job.assigned?.should be_true

    event = mechanic.events.last
    event.date_start.should be_eql expected_date
    (event.date_start + event.time_start.hour.hour).should be_eql expected_datetime
    (event.date_start + event.time_end.hour.hour).should be_eql expected_datetime + 2.hour

    mechanic.events.count.should eq 1
    mail_deliveries.count.should eq 3
  end

  def select_time_slot
    find('.fc-agenda-slots tr:nth-of-type(5) td.fc-widget-content').click
    find('#job_scheduled_at', visible: false)[:value].should include expected_datetime.strftime('%Y-%m-%dT%H:%M')
  end
end
