require 'spec_helper'

feature 'Soft delete car' do
  let(:user) { create :user }
  let(:mechanic) { create :mechanic }
  let!(:job) { create :job, :completed, :with_service, user: user, mechanic: mechanic }

  subject { page }

  context 'User pages' do
    specify 'my cars page' do
      login_user user
      visit users_cars_path
      should have_content car_name
      delete_car
      visit users_cars_path
      should have_no_content car_name
    end
  end

  context 'Mechanic pages' do
    specify 'dashboard' do
      login_mechanic mechanic
      visit mechanics_dashboard_path
      should have_content car_name
      delete_car
      visit mechanics_dashboard_path
      should have_content car_name
    end

    specify 'completed job tab on my jobs page', :js do
      login_mechanic mechanic
      visit mechanics_jobs_path
      click_on 'Completed Jobs'
      should have_content car_name
      delete_car
      visit mechanics_jobs_path
      click_on 'Completed Jobs'
      should have_content car_name
    end
  end

  context 'Admin pages' do
    scenario 'edit job page', :js do
      login_admin
      visit edit_admins_job_path(job)
      should have_content car_name
      delete_car
      visit edit_admins_job_path(job)
      should have_content car_name
    end
  end

  def car_name
    job.car.display_title
  end

  def delete_car
    job.car.destroy
  end
end
