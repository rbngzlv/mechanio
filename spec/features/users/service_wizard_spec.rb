require 'spec_helper'

describe 'Service wizard', js: true do

  let(:user)          { create :user }
  let(:make)          { create :make }
  let(:model)         { create :model, make: make }
  let!(:variation)    { create :model_variation, model: model, make: make }
  let!(:service_plan) { create :service_plan, make: make, model: model, model_variation: variation }
  let!(:state)        { create :state, name: 'State' }

  it 'asks new user to login after Contact step' do
    visit root_path
    click_on 'Car needs servicing'

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

    verify_current_step 'Quote'
    verify_sidebar 4, 'LOCATION', "Broadway 54, ap. 1 Suburb #{state.name}, 1234"
    verify_quote

    verify_job_created
  end

  it 'lists existing user cars', pending: 'need shared db connection for this test to work' do
    car = create :car, user: user, model_variation: variation
    ap car.model_variation
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

    verify_current_step 'Quote'
    verify_job_created
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
    click_on 'Continue'
  end

  def fill_in_address
    fill_in 'Street address', with: 'Broadway 54, ap. 1'
    fill_in 'Suburb', with: 'Suburb'
    fill_in 'Postcode', with: '1234'
    select  state.name, from: 'location_state_id'
    fill_in 'job_contact_email', with: 'email@host.com'
    fill_in 'job_contact_phone', with: '123 456789'
    click_on 'Continue'
  end

  def select_service_plan
    select service_plan.display_title, from: 'job_task_service_plan_id'
    fill_in 'job_task_note', with: 'A note goes here'
    click_on 'Continue'
  end

  def verify_quote
    page.should have_css 'h4', text: 'Here is your quote'
    page.should have_css 'h4', text: service_plan.cost
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

  def verify_job_created
    user.reload.jobs.count.should eq 1
    user.jobs.last.status.should eq 'pending'
  end

  def screenshot
    page.driver.render '/Users/bob/Desktop/screen.png', full: true
  end
end
