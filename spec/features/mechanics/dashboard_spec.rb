require 'spec_helper'

feature 'dashboard page' do
  let(:mechanic) { create :mechanic, description: nil }
  let(:user)    { create :user, first_name: 'John', last_name: 'Dow' }
  let(:job)     { create :job, :completed, :with_service, user: user, mechanic: mechanic }
  let(:rating)  { create :rating, user: user, mechanic: mechanic, job: job }
  let(:unpublished_rating)  { create :rating, user: user, mechanic: mechanic, job: job, published: false }

  subject { page }

  before do
    login_mechanic mechanic
    visit mechanics_dashboard_path
  end

  specify 'shows basic profile information' do
    page.should have_css 'h4', text: mechanic.full_name
    page.should have_link 'Add some information about yourself', href: edit_mechanics_profile_path
    page.should have_css '.verified-icons i', count: 5
  end

  context 'no customer reviews' do
    specify 'shows a message' do
      page.should have_css 'h5', text: 'Customer Reviews'
      page.should have_css 'h5', text: 'No reviews'
    end
  end

  context 'some reviews left' do
    before do
      mechanic.ratings << rating
      mechanic.save
      visit mechanics_dashboard_path
    end

    specify 'shows reviews' do
      within '.review-block' do
        page.should have_content 'John Dow'
        page.should have_content job.car.display_title

        within '.rating' do
          first('.meter')[:style].should eq 'width: 68%'
        end
      end
    end
  end

  context 'unpublished review' do
    before do
      mechanic.ratings << unpublished_rating
      mechanic.save
      visit mechanics_dashboard_path
    end

    specify 'does not show the review' do
      page.should have_css 'h5', text: 'Customer Reviews'
      page.should have_css 'h5', text: 'No reviews'
    end
  end

  context 'jobs' do
    specify 'notify about empty job list' do
      should have_content 'No upcoming jobs'
      should have_content 'No completed jobs'
    end

    scenario 'upcoming jobs' do
      job = create :job, :assigned, :with_service, mechanic: mechanic
      visit mechanics_dashboard_path
      within '.col-md-9 > .row:nth-child(2)' do
        should have_selector '.panel-title', text: 'Upcoming Jobs'
        should have_content "#{job.client_name}"
        should have_content "#{job.scheduled_at.to_s(:date_time)}"
      end
    end

    scenario 'completed jobs' do
      job = create :job, :completed, :with_service, mechanic: mechanic
      visit mechanics_dashboard_path
      within '.col-md-9 > .row:nth-child(3)' do
        should have_selector '.panel-title', text: 'Completed Jobs'
        should have_content "#{job.client_name}"
        should have_content "#{job.scheduled_at.to_s(:date_time)}"
      end
    end
  end

  specify 'N review should be link to profile' do
    visit mechanics_dashboard_path
    click_link '0 Reviews'
    should have_selector 'li.active', text: 'My Profile'
  end

  context 'edit avatar by clicking on the profile picture' do
    specify 'form can upload photo' do
      image_path = "#{Rails.root}/spec/fixtures/test_img.jpg"
      visit mechanics_dashboard_path
      attach_file('mechanic_avatar', image_path)
      expect {
        click_button 'Save'
      }.to change { mechanic.reload.avatar? }.from(false).to(true)
    end
  end
end
