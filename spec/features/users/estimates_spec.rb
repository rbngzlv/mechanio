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
    let!(:pending_job)   { create :job, :pending, :with_discount, user: user }
    let!(:estimated_job) { create :job, :estimated, :with_service, :with_discount, user: user }

    it 'should show estimates for all pended jobs' do
      visit users_dashboard_path

      within('.nav-stacked') { click_link 'My Estimates' }

      within 'li.active' do
        should have_content 'My Estimates'
        should have_content '2'
      end

      within '.panel:nth-child(1)' do
        should have_content estimated_job.created_at.to_s(:date)
        should have_content estimated_job.car.display_title
        estimated_job.tasks.each do |task|
          should have_css "tr", text: "#{task.title} #{number_to_currency task.cost}"
        end
        should have_css "tr", text: "Discount $70"
        should have_css "tr", text: "Total Fees $280"
        should have_link 'Book Appointment'
      end

      within '.panel:nth-child(2)' do
        should have_content pending_job.created_at.to_s(:date)
        should have_content pending_job.car.display_title
        pending_job.tasks.each do |task|
          should have_css "tr", text: "#{task.title} pending"
        end
        should have_css "tr", text: "Discount pending"
        should have_css "tr", text: "Total Fees pending"
        should have_no_link 'Book Appointment'
      end
    end
  end
end
