require 'spec_helper'

feature 'payment page spec' do
  let(:user)     { create :user }
  let(:mechanic) { create :mechanic, first_name: 'First', last_name: 'Last',
    years_as_a_mechanic: 2 }
  let!(:job)     { create :assigned_job, user: user, mechanic: mechanic }

  before { login_user user }

  it do
    visit new_users_job_credit_card_path(job)
    # save_and_open_page
    page.should have_css 'h4', text: '1,000 kms / 6 months service'
    page.should have_css 'tr:nth-child(1)', text: 'First Last 2 years experience'
    page.should have_css 'tr:nth-child(3)', text: 'Jan 29, 2014(Monday) 17:00'
    page.should have_css 'tr:nth-child(4)', text: 'display car name'
    page.should have_css 'tr:nth-child(5)', text: 'location'
    # price break down
    # button text
    # mechanic POPUP
  end
end
