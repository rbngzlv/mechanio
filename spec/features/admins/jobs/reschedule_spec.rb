require 'spec_helper'

describe 'Reschedule appointment' do
  let(:job)          { create :job, :assigned, :with_service, scheduled_at: previous_date }
  let(:previous_date) { Time.now.advance(days: 1) }
  let(:mechanic_name) { job.mechanic.full_name }

  before { login_admin }

  it 'reschedules appointment', :js do
    visit edit_admins_job_path(job)

    click_on 'Reschedule'

    expect do
      click_timeslot
      click_on 'Reschedule'
    end.to change { job.reload.scheduled_at }
  end

  def click_timeslot
    first('.fc-agenda-slots .fc-slot2 td.fc-widget-content').click
  end
end
