require 'spec_helper'

feature 'estimates page' do
  let(:user) { create :user }

  before { login_user user }

  subject { page }

  context 'when user is not have estimates' do
    it 'should have message about emty estimates list' do
      visit users_estimates_path
      should have_content 'You have no estimates'
    end
  end

  context 'when user has estimates' do
    let!(:job) { create :job, :pending, user: user }
    let!(:estimated_job) { create :job_with_service, :estimated, user: user }

    it 'should show estimates for all pended jobs' do
      visit users_dashboard_path

      within('.wrap > .container') { click_link 'My Estimates' }

      within 'li.active' do
        should have_content 'My Estimates'
        should have_content '2'
      end

      within '.panel:nth-child(2)' do
        should have_content job.created_at.to_s(:date)
        should have_content job.car.display_title
        job.tasks.each do |task|
          should have_content task.type
          should have_content task.title
          should have_content task.cost
        end
        should have_content job.cost
        should have_no_link 'Book Appointments'
      end
      within('.panel:nth-child(1)') { should have_link 'Book Appointments' }
    end
  end
end
