require 'spec_helper'

feature 'Jobs page' do
  before { login_admin }

  it 'should can be accessable from main admin page' do
    visit admin_dashboard_path

    click_link 'Jobs'

    current_path.should be_eql(admin_jobs_path)
  end

  context 'should show general info about job' do
    let!(:job1) { create :job_with_service }
    let!(:job2) { create :job_with_service, tasks: [create(:task, cost: nil)], mechanic: create(:mechanic) }

    before { visit admin_jobs_path }

    subject { page }

    scenario 'check content' do
      within 'tbody' do
        within 'tr:nth-child(1)' do
          should have_content job1.status
          should have_content job1.title
          should have_content job1.created_at.to_s(:db)
          should have_content job1.user.full_name
          should have_content job1.date.to_s(:db)
          should have_content 'unassigned'
          should have_content job1.cost
          should have_link "Edit"
        end

        within 'tr:nth-child(2)' do
          should have_content job2.mechanic.full_name
          should have_content 'pending'
          should have_link "Edit"
        end
      end
    end
  end

  scenario 'edit job items', :js do
    job = create :job, :with_service, :with_repair

    visit edit_admin_job_path(job)

    page.should have_css '.grand-total td', text: '$525.50'

    within all('.item-forms')[0] do
      click_on 'Add item'
      click_on 'Part'
      fill_in 'Part name', with: 'Brake disc'
      fill_in 'Quantity', with: '1'
      fill_in 'Cost', with: '56'
      click_on 'Add'
    end

    page.all('form table')[0].all('tr')[2].text.should eq 'Brake disc 1 x $56.00 $56.00'
    page.should have_css '.grand-total td', text: '$581.50'
  end
end
