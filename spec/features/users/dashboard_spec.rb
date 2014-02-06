require 'spec_helper'

feature 'dashboard page' do
  let(:user) { create :user }

  subject { page }

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
    closest_appointment = create :assigned_job, user: user, scheduled_at: scheduled_time
    another_appointment = create :assigned_job, user: user, scheduled_at: (scheduled_time + 1.day)
    mechanic = closest_appointment.mechanic
    visit users_dashboard_path

    within '.user-closest-appointment' do
      page.should have_css 'h4', text: 'Booked Appointments'
      page.should have_content mechanic.full_name
      page.should have_css '.reviews-row', text: "#{mechanic.reviews} Reviews"
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

    closest_estimate = create :job_with_service, :estimated, user: user, created_at: Date.today
    another_estimate = create :job_with_service, :estimated, user: user, created_at: Date.yesterday
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

  context 'description block' do
    it 'contains user full_name' do
      page.should have_selector 'h4', text: user.full_name
    end

    it 'should has link to reviews' do
      click_link "Reviews Left: #{user.reviews}"
      page.should have_css 'h5', text: 'Reviews Left'
    end

    it 'should show description' do
      page.should have_content "Add some information about yourself"

      user.description = 'USER DESCRIPTION'
      user.save
      visit users_dashboard_path
      within '.user-panel-body .panel.nested-panel' do
        page.should have_css 'h5', text: "Hi, my name is #{user.full_name}"
        page.should have_css 'p',  text: 'USER DESCRIPTION'
      end
      page.should have_no_content "Add some information about yourself"
    end

    it 'contains social connections status' do
      visit users_dashboard_path
      within '.user-panel-body .panel.nested-panel' do
        page.should have_no_css '.icon-facebook-sign'
        page.should have_no_css '.icon-google-plus-sign'
      end

      create :authentication, :facebook, user: user
      visit users_dashboard_path
      within '.user-panel-body .panel.nested-panel' do
        page.should have_css '.icon-facebook-sign'
        page.should have_no_css '.icon-google-plus-sign'
      end

      create :authentication, :gmail, user: user
      visit users_dashboard_path
      within '.user-panel-body .panel.nested-panel' do
        page.should have_css '.icon-facebook-sign'
        page.should have_css '.icon-google-plus-sign'
      end
    end

    it 'shows verified icons' do
      within '.verified-icons' do
        find('i:nth-child(1)')[:class].should_not match /disabled/
        find('i:nth-child(2)')[:class].should match /icon-mobile-phone/
        find('i:nth-child(2)')[:class].should_not match /disabled/
        find('i:nth-child(3)')[:class].should_not match /disabled/
      end
    end

    context 'editing avatar feature' do
      specify 'form can upload photo' do
        image_path = "#{Rails.root}/spec/features/fixtures/test_img.jpg"
        visit users_dashboard_path
        attach_file('user_avatar', image_path)
        expect {
          click_button 'Save'
        }.to change { user.reload.avatar? }.from(false).to(true)
        current_path.should be_eql users_dashboard_path
      end

      specify 'form should be hidden' do
        should have_selector '#user_avatar', visible: false
        should have_selector 'input[type=submit]', visible: false
      end
    end
  end
end
