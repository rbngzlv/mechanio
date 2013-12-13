require 'spec_helper'

describe 'Service wizard', js: true do
  include ActionView::Helpers::NumberHelper

  let(:user)          { create :user }
  let(:make)          { create :make }
  let(:model)         { create :model, make: make }
  let!(:variation)    { create :model_variation, model: model, make: make }
  let!(:service_plan) { create :service_plan, make: make, model: model, model_variation: variation }
  let!(:state)        { create :state, name: 'State' }

  before do
    reset_mail_deliveries
  end

  it 'asks user to login after Contact step' do
    visit root_path
    click_on 'Car Needs Servicing'

    verify_current_step 'Car Details'
    add_new_car

    verify_current_step 'Diagnose'
    verify_sidebar 2, 'VEHICLE', variation.display_title
    select_service_plan

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
  end

  it 'saves location in profile when a new user signs up' do
    visit service_path

    verify_current_step 'Car Details'
    add_new_car

    verify_current_step 'Diagnose'
    verify_sidebar 2, 'VEHICLE', variation.display_title
    select_service_plan

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

    visit edit_users_profile_path
    page.should have_field 'Address', with: 'Broadway 54, ap. 1'
  end

  it 'lists existing user cars' do
    car = create :car, user: user, model_variation: variation

    login_user user
    visit service_path

    verify_current_step 'Car Details'
    select_car(car)

    verify_current_step 'Diagnose'
    verify_sidebar 2, 'VEHICLE', variation.display_title
    select_service_plan

    verify_current_step 'Contact'
    verify_sidebar 3, 'CAR SERVICING', service_plan.display_title
    fill_in_address

    verify_quote
    verify_email_notification
    verify_job_created(user)
  end

  def add_new_car
    page.should have_css 'h5', text: 'ADD YOUR VEHICLE'

    select variation.from_year, from: 'car_year'
    select variation.make.name, from: 'car_make_id'
    select variation.model.name, from: 'car_model_id'
    select variation.detailed_title, from: 'car_model_variation_id'

    fill_in 'Kms', with: '10000'
    find('#car_last_service_date').click
    find('.datepicker-days tr:nth-child(1) td.day:nth-child(1)').click

    click_on 'Continue'
  end

  def select_car(car)
    choose car.display_title
    fill_in 'Kms', with: '10000'

    click_on 'Continue'
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
    click_on 'Continue'
  end

  def verify_quote
    page.should have_css 'h4', text: 'YOUR NEGOTIATED QUOTE'
    find('table.tasks tr:last-child').text.should eq "Total Fees #{number_to_currency service_plan.cost}"
    page.should have_css 'h4', text: 'SELECT A MECHANIC'
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
end
