require 'spec_helper'

describe 'Service wizard', js: true do
  include ActionView::Helpers::NumberHelper

  let(:user)          { create :user, location: location }
  let(:location)      { create :location }
  let(:make)          { create :make }
  let(:model)         { create :model, make: make }
  let!(:variation)    { create :model_variation, model: model, make: make }
  let!(:service_plan) { create :service_plan, make: make, model: model, model_variation: variation }
  let(:another_service_plan) { create :service_plan, make: make, model: model, model_variation: variation }
  let(:last_service_year) { Date.today.year - 1 }
  let(:note)          { 'A note goes here' }
  let(:repair_note)   { 'Repair note' }
  let(:another_note)  { 'Edited note' }

  before do
    reset_mail_deliveries
    create :symptom_tree
    create :sydney_suburb
  end

  context 'logged out' do
    it 'asks user to login after Contact step' do
      visit root_path
      click_on 'Car Needs Servicing'

      verify_current_step 'Car Details'
      add_new_car

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title
      add_a_service_plan
      click_on 'Continue'

      verify_current_step 'Contact'
      verify_sidebar 3, 'CAR SERVICING', service_plan.display_title
      fill_in_address

      within '#social-login-modal' do
        click_link 'Log in'
      end

      within '#login-modal' do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        click_on 'Login'
      end

      verify_quote "#{service_plan.display_title} service $350.00", 'Total Fees $350.00'
      verify_email_notification
      verify_job_estimated(user, 350)
      verify_last_service_kms(user)
    end

    it 'saves location in profile when a new user signs up' do
      visit service_path

      verify_current_step 'Car Details'
      add_new_car

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title
      add_a_service_plan
      click_on 'Continue'

      verify_current_step 'Contact'
      verify_sidebar 3, 'CAR SERVICING', service_plan.display_title
      fill_in_address

      within '#social-login-modal' do
        click_on 'Use regular email sign up'
      end

      expect {
        within('#register-modal') do
          fill_in 'user_first_name', with: 'First'
          fill_in 'user_last_name', with: 'Last'
          fill_in 'user_email', with: 'email@host.com'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_on 'Sign up'
        end
      }.to change { User.count }.by 1

      user = User.last
      verify_quote "#{service_plan.display_title} service $350.00", 'Total Fees $350.00'
      # verify_email_notification
      verify_job_estimated(user, 350)
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
      select_a_car

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title
      add_a_service_plan
      click_on 'Continue'

      verify_current_step 'Contact'
      verify_sidebar 3, 'CAR SERVICING', service_plan.display_title

      page.should have_field 'Street address', with: location.address
      page.should have_field 'Suburb', with: location.suburb_name
      page.should have_field 'job_contact_email', with: user.email
      page.should have_field 'job_contact_phone', with: user.mobile_number
      click_on 'Continue'

      verify_quote "#{service_plan.display_title} service $350.00", 'Total Fees $350.00'
      verify_email_notification
      verify_job_estimated(user, 350)
      verify_last_service_date(user)
    end

    it 'add repair with symptoms' do
      visit root_path
      click_on 'Car Needs Repair'

      verify_current_step 'Car Details'
      select_a_car

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title

      add_repair_symptoms
      click_on 'Add'
      verify_task 1, 'Inspection - break safety inspection', 'Replace the break pads Notes: Repair notes'
      page.should have_link 'Add Service'
      click_on 'Continue'

      verify_current_step 'Contact'
      verify_sidebar 3, 'CAR SERVICING', 'Inspection - break safety inspection'
      click_on 'Continue'
      sleep 2

      verify_quote 'Inspection - break safety inspection $80.00', 'Total Fees $80.00'
      # verify_email_notification
      verify_job_estimated(user, 80)
      verify_last_service_date(user)
    end

    it 'allows to navigate symptoms back and forth' do
      visit root_path
      click_on 'Car Needs Repair'

      verify_current_step 'Car Details'
      select_a_car

      page.should have_css 'h5', text: 'What is happening to your car?'
      all('.symptoms a.btn')[0].click

      page.should have_css 'h5', text: 'What is wrong with the breaks?'
      all('.symptoms a.btn')[0].click

      page.should have_css 'h5', text: 'Our recommendation'
      page.should have_css '.advice', 'Replace the break pads'

      click_on 'Back'
      page.should have_css 'h5', text: 'What is wrong with the breaks?'

      click_on 'Back'
      page.should have_css 'h5', text: 'What is happening to your car?'
    end

    it 'add repair typing in the problem' do
      visit repair_path

      verify_current_step 'Car Details'
      select_a_car

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title
      fill_in 'job_task_description', with: 'Problem description'
      click_on 'Add'

      verify_task 1, 'Inspection', 'Problem description'
    end

    it 'edits notes' do
      visit repair_path

      verify_current_step 'Car Details'
      select_a_car

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title
      add_repair_symptoms
      click_on 'Add'

      verify_task 1, 'Inspection - break safety inspection', 'Replace the break pads'

      within_task(1) { click_on 'Add notes' }
      fill_in 'job_task_note', with: another_note
      click_on 'Save Notes'

      verify_task 1, 'Inspection - break safety inspection', 'Replace the break pads Notes: Edited note'
    end

    it 'edits repair', pending: 'Switched to inline note editing' do
      visit repair_path

      verify_current_step 'Car Details'
      select_a_car

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title
      add_repair_symptoms
      click_on 'Add'

      verify_task 1, 'Inspection - break safety inspection', 'Replace the break pads'

      within_task(1) { find('.edit-task').click }
      fill_in 'job_task_note', with: another_note
      click_on 'Update'

      verify_task 1, 'Inspection - break safety inspection', 'Replace the break pads Notes: Edited note'
    end

    it 'edits service', pending: 'Switched to inline note editing' do
      another_service_plan

      visit service_path

      verify_current_step 'Car Details'
      select_a_car

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title
      add_a_service_plan

      within_task(1) { find('.edit-task').click }
      page.should have_select 'job_task_service_plan_id', selected: service_plan.display_title
      page.should have_field  'job_task_note', with: note

      select_service_plan(another_service_plan, another_note)
      click_on 'Update'
      verify_task 1, another_service_plan.display_title, another_note
    end

    it 'deletes tasks' do
      another_service_plan

      visit service_path

      verify_current_step 'Car Details'
      select_a_car

      verify_current_step 'Diagnose'
      verify_sidebar 2, 'VEHICLE', variation.display_title
      add_a_service_plan

      click_link 'Add Repair'
      add_repair_symptoms
      click_on 'Add'
      verify_task 2, 'Inspection - break safety inspection', 'Replace the break pads'

      within_task(1) { find('.remove-task').click }
      verify_task 1, 'Inspection - break safety inspection', 'Replace the break pads'

      within_task(1) { find('.remove-task').click }
      page.should have_css 'h5', text: 'What is happening to your car?'
      find('button', text: 'Add')[:disabled].should be_true
    end
  end

  def add_new_car
    page.should have_css 'h5', text: 'ADD YOUR VEHICLE'

    select variation.from_year, from: 'car_year'
    select variation.make.name, from: 'car_make_id'
    select variation.model.name, from: 'car_model_id'
    select variation.detailed_title, from: 'car_model_variation_id'

    fill_in 'Kms', with: '1000'
    page.should have_content 'minimum value is 5000'
    page.find_button('Continue', disabled: true)

    fill_in 'Kms', with: '15000'
    page.should have_no_content 'minimum value is 5000'

    click_on 'Continue'
  end

  def select_a_car
    choose car.display_title
    enter_last_service_date
    click_on 'Continue'
  end

  def enter_last_service_date
    select 'February', from: 'car_last_service_month'
    select last_service_year, from: 'car_last_service_year'
  end

  def fill_in_address
    fill_in 'Street address', with: 'Broadway 54, ap. 1'
    autocomplete 'Suburb', 'Syd', 'Sydney, NSW 2012'
    fill_in 'job_contact_email', with: 'email@host.com'
    fill_in 'job_contact_phone', with: '0412345678'
    click_on 'Continue'
  end

  def add_a_service_plan
    select_service_plan
    click_on 'Add'
    verify_task 1, service_plan.display_title, note
  end

  def select_service_plan(plan = nil, custom_note = nil)
    plan ||= service_plan
    select plan.display_title, from: 'job_task_service_plan_id'
    fill_in 'job_task_note', with: custom_note || note
  end

  def add_repair_symptoms(symptom_pos = 0)
    page.should have_css 'h5', text: 'Something else is wrong?'
    page.should have_css 'h5', text: 'What is happening to your car?'
    all('.symptoms a.btn')[0].click

    page.should have_no_css 'h5', text: 'Something else is wrong?'
    page.should have_css 'h5', text: 'What is wrong with the breaks?'
    all('.symptoms a.btn')[symptom_pos].click

    page.should have_no_css 'h5', text: 'Something else is wrong?'
    page.should have_css 'h5', text: 'Our recommendation'
    page.should have_css '.advice', 'Replace the break pads'
    fill_in 'job_task_note', with: 'Repair notes'
  end

  def add_repair_keywords
    fill_in 'Describe any issues you have with your car', with: 'I have 3 wheels'
  end

  def verify_task(position, title, content)
    within_task(position) do
      page.should have_css '.panel-heading', text: title
      page.should have_css '.panel-body',    text: content
    end
  end

  def verify_quote(*rows)
    page.should have_css 'h4', text: 'YOUR NEGOTIATED QUOTE'
    within '.tasks' do
      verify_job rows
    end
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
    within ".wizard-sidebar .panel:nth-of-type(#{position})" do
      page.should have_css 'h5', text: title
      page.should have_css '.panel-body', text: content
    end
  end

  def within_task(position, &block)
    within ".tasks .task:nth-child(#{position})" do
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

  def verify_job_estimated(user, total)
    user.reload.jobs.count.should eq 1
    user.jobs.last.tap do |j|
      j.status.should eq 'estimated'
      j.cost.should eq total
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
