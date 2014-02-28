require 'spec_helper'

feature 'upcoming job details page' do
  let(:mechanic) { create :mechanic }
  let!(:job) { create :job_with_service, :with_repair, :with_inspection,
    :completed, mechanic: mechanic, assigned_at: Date.tomorrow }

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
      page.should have_css 'h4', text: 'Appointment on:'
      page.should have_css 'h4', text: job.scheduled_at.to_s(:date_time_short)
    end
    within '.alert-info + .panel' do
      page.should have_content 'Job ID'
      page.should have_content job.uid
      page.should have_content 'Job received date'
      page.should have_content job.assigned_at.to_s(:date_short)
      page.should have_content 'Client Name'
      page.should have_content job.user.full_name
      page.should have_content job.location.full_address
      page.should have_content job.contact_phone
      page.should have_content job.car.display_title
    end

    page.should have_css 'h4.hx-default', text: 'Job and Labour'
    job.tasks.each do |task|
      case task.type
      when 'Service'
        within "#service_#{task.id}" do
          page.should have_css 'h5.hx-default', text: task.title
          page.should have_css 'p b', text: 'Note'
          page.should have_css 'p', text: 'A note to mechanic'
          page.should have_css 'td:nth-child(1)', text: 'Service Title'
          page.should have_css 'td:nth-child(2)', text: task.task_items.first.itemable.description
          page.should have_css 'td:nth-child(6)', text: '$350.00'
          page.should have_css '.task-cost', text: "$#{task.cost}"
        end
      when 'Repair'
        within "#repair_#{task.id}" do
          page.should have_css 'h5.hx-default', text: task.title
          page.should have_css 'p b', text: 'Note'
          page.should have_css 'p', text: 'A note to mechanic'

          page.should have_css 'td:nth-child(1)', text: 'Part'
          page.should have_css 'td:nth-child(2)', text: 'Break pad'
          page.should have_css 'td:nth-child(3)', text: '2'
          page.should have_css 'td:nth-child(5)', text: '$54'
          page.should have_css 'td:nth-child(6)', text: '$108.00'

          page.should have_css 'td:nth-child(1)', text: 'Labour'
          page.should have_css 'td:nth-child(3)', text: '2 h 30 m'
          page.should have_css 'td:nth-child(5)', text: '$50'
          page.should have_css 'td:nth-child(6)', text: '$125.00'

          page.should have_css 'td:nth-child(1)', text: 'Fixed Amount'
          page.should have_css 'td:nth-child(2)', text: 'Fixed amount'
          page.should have_css 'td:nth-child(6)', text: '$100.00'
          page.should have_css '.task-cost', text: "$#{task.cost}"
        end
      when 'Inspection'
        within "#inspection_#{task.id}" do
          page.should have_css 'h5.hx-default', text: task.title
          page.should have_css 'p b', text: 'Note'
          page.should have_css 'p', text: 'A note to mechanic'
          page.should have_css 'td:nth-child(1)', text: task.title
          page.should have_css 'td:nth-child(5)', text: task.cost
          page.should have_css '.task-cost', text: "$#{task.cost}"
        end
      end
    end

    within '.total' do
      page.should have_content 'Total'
      page.should have_content "$#{job.cost}"
    end

    page.should have_no_selector '.container form'
    page.should have_no_link 'Edit Job'
    page.should have_no_button 'Edit Job'
  end

  it 'has feedback section' do
    visit mechanics_job_path(job)
    page.should have_css 'h4.hx-default', text: 'Feedback'
  end

  it 'should show real feedback', pending: 'feedback mechanism not implemented'
end
