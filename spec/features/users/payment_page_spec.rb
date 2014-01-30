require 'spec_helper'

feature 'payment page spec' do
  let(:user)     { create :user }
  let(:mechanic) { create :mechanic, years_as_a_mechanic: 2 }
  let!(:job)     { create :assigned_job, user: user, mechanic: mechanic, scheduled_at: DateTime.new(2014, 2, 6, 11)}

  before do
    login_user user
    visit new_users_job_credit_card_path(job)
  end

  it 'shows job details' do
    within('section > .panel:nth-of-type(1)') do
      page.should have_css 'h4', text: job.title
      page.should have_css 'tr:nth-child(1)', text: mechanic.full_name
      page.should have_css 'tr:nth-child(1)', text: '2 years of experience'
      page.should have_css 'tr:nth-child(3)', text: '06 Feb 2014 (Thursday) 11:00'
      page.should have_css 'tr:nth-child(4)', text: job.car.display_title
      page.should have_css 'tr:nth-child(5)', text: job.location.full_address
    end
  end

  it 'shows job quote' do
    within('section > .panel:nth-of-type(3)') do
      page.should have_css 'h4', text: 'Price Breakdown'
      page.should have_css 'tr:nth-child(1)', text: job.tasks.first.title
      page.should have_css 'tr:nth-child(1)', text: job.tasks.first.title
      page.should have_css 'tr:nth-child(3)', text: job.cost
      # page.should have_link 'Redeem promo code'
      page.should have_content 'You pay $0 to secure this booking.'
      page.should have_content 'You pay after the job is done.'
    end
  end

  it 'should show mechanic details by clicking on profile block', :js do
    page.should have_button "Book #{mechanic.first_name} for Thu 6/2"
    find('.profile-border.clickable').click
    page.should have_css "#js-mechanic-#{mechanic.id}", visible: true
  end
end
