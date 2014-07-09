require 'spec_helper'

describe 'Reassign job' do
  let!(:job)        { create :job, :assigned, :with_service, location: location, mechanic: mechanic1  }
  let!(:mechanic1)  { create :mechanic, first_name: 'First', mechanic_regions: [create(:mechanic_region, postcode: '1234')] }
  let!(:mechanic2)  { create :mechanic, first_name: 'Second', mechanic_regions: [create(:mechanic_region, postcode: '1234')] }
  let(:location)    { create :location, postcode: '1234' }

  before do
    login_admin
  end

  it 'reassigns job', :js do
    visit edit_admins_job_path(job)

    page.should have_content 'Allocated to First Mechanic'
    click_on 'Reassign'

    page.should_not have_content 'First Mechanic'
    page.should have_content 'Second Mechanic'

    click_timeslot
    click_on 'Reassign'

    page.should have_content 'Allocated to Second Mechanic'
  end

  def click_timeslot
    first('.fc-agenda-slots .fc-slot2 td.fc-widget-content').click
  end
end
