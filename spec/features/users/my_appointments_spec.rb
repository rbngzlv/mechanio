require 'spec_helper'

feature 'My appointments' do
  let(:user)          { create :user, first_name: 'John', last_name: 'Dow' }
  let(:mechanic)      { create :mechanic }
  let(:current_job)   { create :job, :with_service, :estimated, :assigned, mechanic: mechanic, user: user }
  let(:completed_job) { create :job, :with_service, :completed, mechanic: mechanic, user: user, scheduled_at: Time.now.advance(hour: 1) }
  let(:rated_job)     { create :job, :with_service, :completed, mechanic: mechanic, user: user, scheduled_at: Time.now.advance(hour: 2) }
  let(:rating)        { create :rating, job: rated_job, user: user, mechanic: mechanic }
  let(:unpublished_rating)            { create :rating, job: job_with_unpublished_rating, user: user, mechanic: mechanic, published: false }
  let(:job_with_unpublished_rating)   { create :job, :with_service, :completed, mechanic: mechanic, user: user, scheduled_at: Time.now.advance(hour: 3) }

  before do
    login_user user
    reset_mail_deliveries
  end

  specify 'current appointments', :js do
    current_job
    rated_job
    rating
    visit users_appointments_path

    page.should have_css 'li.active a', text: 'Current Appointments'
    page.should have_content "ID: #{current_job.uid}"

    find('.profile-border.clickable').click

    within "#js-mechanic-#{mechanic.id}" do
      page.should have_css 'h5', mechanic.full_name
      page.should have_css 'h5', 'CUSTOMER REVIEWS'

      within '.chat' do
        page.should have_content 'John Dow'
        page.should have_content rated_job.car.display_title
        page.should have_content rated_job.title
        first('.meter')[:style].should eq 'width: 70%'
      end
    end
  end

  describe 'past appointments', :js do
    before do
      completed_job
      rated_job
      job_with_unpublished_rating
      unpublished_rating
      rating

      visit users_appointments_path

      within '.nav-tabs' do
        click_on 'Past Appointments'
      end
    end

    specify 'lists apoointments' do
      page.should have_css 'tr', text: 'Status Job Mechanic Vehicle Date Option'

      within 'tbody' do
        page.should have_css 'tr', text: "Completed #{completed_job.title} #{mechanic.full_name} #{completed_job.car.display_title} #{completed_job.scheduled_at.to_s(:date_short)}"
        page.should have_css 'tr', count: 3
        page.should have_css 'a[data-original-title="Leave Feedback"]', count: 1
      end
    end

    specify 'shows appointment details' do
      all('a[data-original-title="View Job"]')[2].click

      page.should have_css 'td', text: 'Total Fees'
      page.should have_css '.feedback'
      page.should have_content "Hi, I'm your mechanic #{completed_job.mechanic.full_name}"
      page.should have_no_css '.modal'
    end

    specify 'does not show unpublished rating' do
      first('a[data-original-title="View Job"]').click

      page.should have_css 'td', text: 'Total Fees'
      page.should have_no_css '.feedback'
      page.should have_content "Hi, I'm your mechanic #{completed_job.mechanic.full_name}"
    end
  end
end
