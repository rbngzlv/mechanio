require 'spec_helper'

describe 'Service wizard', js: true do
  include ActionView::Helpers::NumberHelper

  let(:user)          { create :user, location: location }
  let(:location)      { create :location }
  let(:make)          { create :make }
  let(:model)         { create :model, make: make }
  let!(:variation)    { create :model_variation, model: model, make: make }
  let!(:service_plan) { create :service_plan, make: make, model: model, model_variation: variation }
  let!(:state)        { create :state, name: 'State' }
  let(:last_service_year) { Date.today.year - 1 }

  before do
    reset_mail_deliveries
    create :symptom_tree
  end

  context 'logged out' do
    it 'asks user to login after Contact step' do
      visit root_path
      click_on 'Car Needs Servicing'

      verify_current_step 'Car Details'
      enter_last_service_kms
      add_new_car

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title
      select_service_plan
      click_on 'Continue'

      verify_current_step 'Contact'
      verify_sidebar 3, 'CAR SERVICING', service_plan.display_title
      fill_in_address

      find('#login-modal').should be_visible
      within '#login-modal' do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        click_on 'Login'
      end

      verify_quote
      verify_email_notification
      verify_job_created(user)
      verify_last_service_kms(user)
    end

    it 'saves location in profile when a new user signs up' do
      visit service_path

      verify_current_step 'Car Details'
      enter_last_service_kms
      add_new_car

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title
      select_service_plan
      click_on 'Continue'

      verify_current_step 'Contact'
      verify_sidebar 3, 'CAR SERVICING', service_plan.display_title
      fill_in_address

      page.should have_css '#login-modal'
      within '#login-modal' do
        click_on 'Sign up'
      end

      page.should have_css '#register-modal'
      within('#register-modal') do
        fill_in 'user_first_name', with: 'First'
        fill_in 'user_last_name', with: 'Last'
        fill_in 'user_email', with: 'email@host.com'
        fill_in 'user_password', with: 'password'
        click_on 'Sign up'
      end

      verify_quote
      # verify_email_notification
      verify_job_created(User.last)
      verify_last_service_kms(User.last)

      visit edit_users_profile_path
      page.should have_field 'Address', with: 'Broadway 54, ap. 1'
    end
  end

  context 'logged in' do
    let!(:car) { create :car, user: user, model_variation: variation }

    before do
      login_user user
    end

    it 'lists user cars and prefills contact step with profile settings' do
      visit service_path

      verify_current_step 'Car Details'
      select_car(car)
      enter_last_service_date
      click_on 'Continue'

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title
      select_service_plan
      click_on 'Continue'

      verify_current_step 'Contact'
      verify_sidebar 3, 'CAR SERVICING', service_plan.display_title

      page.should have_field 'Street address', with: location.address
      page.should have_field 'Suburb', with: location.suburb
      page.should have_field 'Postcode', with: location.postcode
      page.should have_select 'location_state_id', selected: location.state.name
      page.should have_field 'job_contact_email', with: user.email
      page.should have_field 'job_contact_phone', with: user.mobile_number
      click_on 'Continue'

      verify_quote
      verify_email_notification
      verify_job_created(user)
      verify_last_service_date(user)
    end

    it 'add repair with symptoms' do
      visit root_path
      click_on 'Car Needs Repair'

      verify_current_step 'Car Details'
      select_car(car)
      enter_last_service_date
      click_on 'Continue'

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title

      page.should have_css 'h5', text: 'FIX CAR PROBLEM'
      add_repair_symptoms
      click_on 'Continue'

      verify_current_step 'Contact'
      verify_sidebar 3, 'CAR SERVICING', 'Diagnose car problem'
      click_on 'Continue'

      verify_pending_quote
      # verify_email_notification
      verify_job_pending(user)
      verify_last_service_date(user)
    end

    it 'add repair with description' do
      visit service_path

      verify_current_step 'Car Details'
      select_car(car)
      enter_last_service_date
      click_on 'Continue'

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title

      click_link 'Add Repair'
      add_repair_description
      click_on 'Continue'

      verify_current_step 'Contact'
      verify_sidebar 3, 'CAR SERVICING', 'Diagnose car problem'
      click_on 'Continue'

      verify_pending_quote
      # verify_email_notification
      verify_job_pending(user)
      verify_last_service_date(user)
    end

    it 'allows to edit tasks from sidebar' do
      visit service_path

      verify_current_step 'Car Details'
      select_car(car)
      enter_last_service_date
      click_on 'Continue'

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title

      select_service_plan
      click_link 'Add Repair'
      add_repair_description
      click_on 'Continue'

      verify_current_step 'Contact'

      within_sidebar_block(3) { find('li:nth-child(1) a').click }
      verify_current_step 'Diagnose'
      page.should have_css 'h5', "PLEASE PICK A SERVICE INTERVAL YOU'LL LIKE OUR PROFESSIONAL MOBILE MECHANIC TO PERFORM"

      within_sidebar_block(3) { find('li:nth-child(2) a').click }
      verify_current_step 'Diagnose'
      page.should have_css 'h5', "FIX CAR PROBLEM"
    end
  end

  def add_new_car
    page.should have_css 'h5', text: 'ADD YOUR VEHICLE'

    select variation.from_year, from: 'car_year'
    select variation.make.name, from: 'car_make_id'
    select variation.model.name, from: 'car_model_id'
    select variation.detailed_title, from: 'car_model_variation_id'
    click_on 'Continue'
  end

  def select_car(car)
    choose car.display_title
  end

  def enter_last_service_kms
    fill_in 'Kms', with: '15000'
  end

  def enter_last_service_date
    select 'February', from: 'car_last_service_month'
    select last_service_year, from: 'car_last_service_year'
  end

  def fill_in_address
    fill_in 'Street address', with: 'Broadway 54, ap. 1'
    fill_in 'Suburb', with: 'Suburb'
    fill_in 'Postcode', with: '1234'
    select  state.name, from: 'location_state_id'
    fill_in 'job_contact_email', with: 'email@host.com'
    fill_in 'job_contact_phone', with: '0412345678'
    click_on 'Continue'
  end

  def select_service_plan
    select service_plan.display_title, from: 'job_task_service_plan_id'
    fill_in 'job_task_note', with: 'A note goes here'
  end

  def add_repair_symptoms
    click_on 'Looks like'
    check 'Sway - Gradual movement from side to side.'
    check 'Drifts - Gradual movements to one side.'
  end

  def add_repair_description
    fill_in 'Describe any issues you have with your car', with: 'I have 3 wheels'
  end

  def verify_quote
    page.should have_css 'h4', text: 'YOUR NEGOTIATED QUOTE'
    find('table.tasks tr:last-child').text.should eq "Total Fees #{number_to_currency service_plan.cost}"
    page.should have_css 'h4', text: 'SELECT A MECHANIC'
  end

  def verify_pending_quote
    page.should have_css 'h4', text: 'Thanks for requesting a quote!'
    page.should have_content "We'll give you a call"
    page.should have_link 'Check my job status'
  end

  def verify_current_step(step)
    page.should have_css 'li.active a', text: step
  end

  def verify_sidebar(position, title, content)
    within_sidebar_block(position) do
      page.should have_css 'h5', text: title
      page.should have_css '.panel-body', text: content
    end
  end

  def within_sidebar_block(position, &block)
    within ".wizard-sidebar .panel:nth-of-type(#{position})" do
      yield
    end
  end

  def verify_email_notification
    mail_deliveries.count.should eq 2
    mail_deliveries[0].tap do |m|
      m.to.should eq ['admin@example.com']
      m.subject.should eq 'Job estimated'
    end
    mail_deliveries[1].tap do |m|
      m.to.should eq [user.email]
      m.subject.should include "We've got a quote for your"
    end
  end

  def verify_job_created(user)
    user.reload.jobs.count.should eq 1
    user.jobs.last.tap do |j|
      j.status.should eq 'estimated'
      j.cost.should eq 350
    end
  end

  def verify_job_pending(user)
    user.reload.jobs.count.should eq 1
    user.jobs.last.tap do |j|
      j.status.should eq 'pending'
      j.cost.should eq nil
    end
  end

  def verify_last_service_kms(user)
    user.cars.last.last_service_kms.should eq 15000
  end

  def verify_last_service_date(user)
    user.cars.last.last_service_date.should eq Date.new(last_service_year, 2, 1)
  end
end
