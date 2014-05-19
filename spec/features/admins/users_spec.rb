require 'spec_helper'

feature 'Admin user management' do
  let!(:user) { create :user, first_name: 'Joe', last_name: 'User', email: 'joe@email.com', mobile_number: '0412345667' }

  subject { page }

  before do
    login_admin
  end

  it 'navigates through users section' do
    visit admins_dashboard_path
    click_link 'Users'

    should have_css '.navbar-brand', text: 'Manage users'
    should have_css 'td', text: user.full_name
    click_link 'Details'

    should have_css 'h4', text: 'User details'
    should have_css 'dd', text: user.full_name
  end

  it 'lists available users' do
    visit admins_users_path

    signup_date = user.created_at.to_s(:date_short)

    page.should have_css '.navbar-brand', 'Manage users'
    page.should have_css 'tr', text: 'Status Name Email Mobile Signup date'
    page.should have_css 'tr', text: "Active Joe User joe@email.com 0412345667 #{signup_date}"
  end

  it 'searches users by keywords' do
    another_user = create :user, first_name: 'Jimmy', last_name: 'Smith', email: 'jimmy@example.com', mobile_number: '0412345668'

    visit admins_users_path

    page.should have_css 'tbody tr', count: 2

    fill_in 'query', with: 'Jim'
    click_on 'Search'

    signup_date = another_user.created_at.to_s(:date_short)

    page.should have_css 'tbody tr', count: 1
    page.should have_css 'tr', text: "Active Jimmy Smith jimmy@example.com 0412345668 #{signup_date}"
  end

  context 'shows user details' do
    scenario 'should show user appointments' do
      user.jobs << create(:job, :pending, :with_service, user: user)
      user.jobs << create(:job, :estimated, :with_service, user: user)
      user.jobs << create(:job, :assigned, :with_service, user: user)
      visit admins_user_path(user)

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

    it 'show notice if user does not have appointments' do
      visit admins_user_path(user)
      should have_content 'This user has no appointments'
    end
  end

  it 'deletes a user' do
    expect do
      visit admins_user_path(user)
      click_link 'Delete'
    end.to change { User.count }.by -1

    should have_css '.alert', text: 'User successfully deleted.'
  end
end
