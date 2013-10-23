require 'spec_helper'

feature 'Admin user management' do
  let!(:user) { create :user }

  subject { page }

  before do
    login_admin
  end

  it 'navigates through users section' do
    visit admin_dashboard_path
    click_link 'Users'

    should have_css 'h4', text: 'Manage users'
    should have_css 'td', text: user.full_name
    click_link 'Details'

    should have_css 'h4', text: 'User details'
    should have_css 'dd', text: user.full_name
  end

  it 'lists available users' do
    visit admin_users_path

    should have_css 'td', text: user.full_name
  end

  context 'shows user details' do
    scenario 'should show user appointments' do
      user.jobs << create(:job_with_service, :pending, user: user)
      user.jobs << create(:job_with_service, :estimated, user: user)
      user.jobs << create(:assigned_job, user: user)
      visit admin_user_path(user)

      should have_css 'h4', text: 'User details'
      should have_css 'dd', text: user.full_name

      within 'tbody' do
        user.jobs.each_with_index do |job, index|
          within "tr:nth-child(#{ index + 1 })" do
            should have_content job.status.capitalize
            should have_content job.title
            should have_content job.created_at.to_s(:date)
            should have_content job.scheduled_at? ? job.scheduled_at.to_s(:date_time) : ''
            should have_content job.mechanic ? job.mechanic.full_name : 'unassigned'
            should have_content job.cost
            should have_link "Edit"
          end
        end

        within("tr:nth-child(1)") { click_link "Edit" }
      end
      should have_css('h4', text: user.jobs[0].title)
    end
  end

  it 'deletes a user' do
    expect do
      visit admin_user_path(user)
      click_link 'Delete'
    end.to change { User.count }.by -1

    should have_css '.alert', text: 'User succesfully deleted.'
  end
end
