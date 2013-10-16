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

  context 'edit job' do
    scenario 'add service', :js do
      job = create :job, :with_repair
      service_plan = create :service_plan, model_variation: job.car.model_variation

      visit edit_admin_job_path(job)

      page.should have_css '.task', count: 1
      page.should have_css '.grand-total td', text: '$233.00'

      task_row(1, 1).should eq 'Replace break pads'
      task_row(1, 2).should eq 'Break pad 2 x $54.00 $108.00'
      task_row(1, 3).should eq 'Replace break pads 2:30 x $50.00 $125.00'
      task_row(1, 4).should eq 'Total: $233.00'
      grand_total.should eq '$233.00'

      within '.task-form' do
        click_on 'Add task'
        click_on 'Service'
      end

      within '.service-form' do
        select service_plan.display_title, from: 'service-plan'
        fill_in 'Note for mechanic', with: 'A note'
        click_on 'Add'
      end

      task_row(2, 1).should eq 'Service: 10,000 kms / 6 months'
      task_row(2, 2).should eq 'Fixed amount - 10,000 kms / 6 months $350.00'
      task_row(2, 3).should eq 'Total: $350.00'
      grand_total.should eq '$583.00'

      within '.task-form' do
        click_on 'Add task'
        page.should have_no_css '.dropdown-menu a', text: 'Service'
      end
    end

    scenario 'add repair', :js do
      job = create :job, :with_service

      visit edit_admin_job_path(job)

      task_row(1, 1).should eq 'Service: 10,000 kms / 6 months'
      task_row(1, 2).should eq 'Fixed amount - 10,000 kms / 6 months $350.00'
      task_row(1, 3).should eq 'Total: $350.00'
      grand_total.should eq '$350.00'

      within '.task-form' do
        click_on 'Add task'
        page.should have_no_css '.dropdown-menu a', text: 'Service'
        click_on 'Repair'
      end

      within '.repair-form' do
        fill_in 'Title', with: 'Fix breaks'
        fill_in 'Note for mechanic', with: 'A note'
        click_on 'Add'
      end

      task_row(2, 1).should eq 'Fix breaks'
      task_row(2, 2).should eq 'Total: pending'
      grand_total.should eq 'pending'

      add_part_to_task 2

      task_row(2, 2).should eq 'Brake disc 1 x $56.00 $56.00'
      task_row(2, 3).should eq 'Total: $56.00'
      grand_total.should eq '$406.00'

      add_labour_to_task 2

      task_row(2, 3).should eq 'Changing break pads 2:00 x $50.00 $100.00'
      task_row(2, 4).should eq 'Total: $156.00'
      grand_total.should eq '$506.00'

      add_fixed_to_task 2

      task_row(2, 4).should eq 'Fixed amount - Some fixed amount $175.00'
      task_row(2, 5).should eq 'Total: $331.00'
      grand_total.should eq '$681.00'
    end
  end

  def add_part_to_task(task)
    within ".task:nth-child(#{task})" do
      click_on 'Add item'
      click_on 'Part'
      fill_in 'Part name', with: 'Brake disc'
      fill_in 'Quantity', with: '1'
      fill_in 'Cost', with: '56'
      click_on 'Add'
    end
  end

  def add_labour_to_task(task)
    within ".task:nth-child(#{task})" do
      click_on 'Add item'
      click_on 'Labour'
      fill_in 'Description', with: 'Changing break pads'
      select '2', from: find('.labour-hours')[:id]
      select '0', from: find('.labour-minutes')[:id]
      click_on 'Add'
    end
  end

  def add_fixed_to_task(task)
    within ".task:nth-child(#{task})" do
      click_on 'Add item'
      click_on 'Fixed'
      fill_in 'Description', with: 'Some fixed amount'
      fill_in 'Cost', with: '175'
      click_on 'Add'
    end
  end

  def task_row(task, row)
    find(".task:nth-child(#{task}) tr:nth-child(#{row})").text
  end

  def grand_total
    find('.grand-total td').text
  end

    page.all('form table')[0].all('tr')[2].text.should eq 'Brake disc 1 x $56.00 $56.00'
    page.should have_css '.grand-total td', text: '$581.50'
  end
end
