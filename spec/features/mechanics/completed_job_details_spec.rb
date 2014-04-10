require 'spec_helper'

feature 'upcoming job details page' do
  let(:mechanic) { create :mechanic }
  let!(:job) { create :job, :completed, :with_service, :with_repair, :with_inspection, :with_discount,
    mechanic: mechanic, assigned_at: Date.tomorrow }

  before { login_mechanic mechanic }

  specify 'dashboard should have link to completed job details' do
    visit mechanics_dashboard_path
    expect do
      within('.completed') { click_link 'View Details' }
    end.to change { page.has_content? job.uid }.from(false).to(true)
  end

  specify 'my jobs page should have link to completed job details' do
    visit mechanics_jobs_path
    expect do
      within('#past-jobs') { click_link 'View Details' }
    end.to change { page.has_content? job.uid }.from(false).to(true)
  end

  it 'should show job details' do
    visit mechanics_job_path(job)

    page.should have_link 'View Receipt'

    within '.alert-info' do
      date = job.scheduled_at.to_s(:date_time_short)
      page.should have_css 'h4', text: "Appointment on: #{date}"
    end

    within '.alert-info + .panel' do
      date = job.assigned_at.to_s(:date_short)
      page.should have_css "p", text: "Job ID: #{job.uid}"
      page.should have_css "p", "Job received date: #{date}"
      page.should have_css "p", "Client Name: #{job.user.full_name}"
      page.should have_css "p", job.location.full_address
      page.should have_css "p", job.contact_phone
      page.should have_css "p", job.car.display_title
    end

    page.should have_css 'h4.hx-default', text: 'Job and Labour'

    job.tasks.each do |task|
      case task.type
      when 'Service'
        within "#service_#{task.id}" do
          item_title = task.task_items.first.itemable.description
          page.should have_css 'h5.hx-default', text: task.title
          page.should have_css 'p', text: 'Note: A note to mechanic'

          page.should have_css 'tr', text: "Service Title #{item_title} $350.00"

          page.should have_css '.task-cost', text: "#{number_to_currency task.cost}"
        end
      when 'Repair'
        within "#repair_#{task.id}" do
          page.should have_css 'h5.hx-default', text: task.title
          page.should have_css 'p', text: 'Note: A note to mechanic'

          page.should have_css 'tr', text: 'Part Break pad 2 x $54.00 $108.00'
          page.should have_css 'tr', text: 'Labour 2 h 30 m x $50.00 $125.00'
          page.should have_css 'tr', text: 'Fixed Amount Fixed amount $100.00'

          page.should have_css '.task-cost', text: "#{number_to_currency task.cost}"
        end
      when 'Inspection'
        within "#inspection_#{task.id}" do
          page.should have_css 'h5.hx-default', text: task.title
          page.should have_css 'p', text: 'Note: A note to mechanic'

          page.should have_css 'tr', text: 'Break pedal vibration free'

          page.should have_css '.task-cost', text: "free"
        end
      end
    end

    page.should have_css '.total', 'Discount $136.60'
    page.should have_css '.total', 'Total $546.40'
  end

  it 'has feedback section' do
    visit mechanics_job_path(job)
    page.should have_css 'h4.hx-default', text: 'Feedback'
  end

  it 'should show real feedback', pending: 'feedback mechanism not implemented'
end
