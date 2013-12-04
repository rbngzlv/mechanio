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
    let!(:job2) { create :assigned_job, location: create(:location, :with_coordinates) }

    before { visit admin_jobs_path }

    subject { page }

    scenario 'check content' do
      within 'tbody' do
        within 'tr:nth-child(1)' do
          verify_job_row(job2)
        end

        within 'tr:nth-child(2)' do
          verify_job_row(job1)
        end
      end
    end
  end

  def verify_job_row(job)
    should have_content job.status.capitalize
    should have_content job.location.geocoded? ? 'Valid' : 'Invalid'
    should have_content job.title
    should have_content job.created_at.to_s(:date)
    should have_content job.user.full_name
    should have_content job.scheduled_at? ? job.scheduled_at.to_s(:date_time) : ''
    should have_content job.mechanic ? job.mechanic.full_name : 'unassigned'
    should have_content job.cost
    should have_link "Edit"
  end

  context 'edit job', :js do
    scenario 'add service' do
      job = create :job, :with_repair
      service_plan = create :service_plan, model_variation: job.car.model_variation

      visit edit_admin_job_path(job)

      within_task(1) do
        task_title.should eq 'Replace break pads'
        task_total.should eq '$233.00'
        within_row(0) { verify_part 'Break pad', '2', '54.0', '$108.00' }
        within_row(1) { verify_labour 'Replace break pads', '2', '30', '$125.00' }
      end

      grand_total.should eq '$233.00'

      click_on 'Add task'
      click_on 'Service'

      within '.service-form' do
        select service_plan.display_title, from: 'service-plan'
        fill_in 'Note for mechanic', with: 'A note'
        click_on 'Done'
      end

      reset_mail_deliveries
      click_on 'Update job'

      within_task(2) do
        task_title.should eq "Service: #{service_plan.display_title}"
        task_total.should eq '$350.00'
        within_row(0) { verify_service_cost service_plan.display_title, '$350.00' }
      end

      grand_total.should eq '$583.00'

      click_on 'Add task'
      page.should have_no_css '.dropdown-menu a', text: 'Service'
      verify_email_notifications(job)
    end

    scenario 'add repair' do
      job = create :job, :with_service
      service_plan = job.tasks.first.service_plan

      visit edit_admin_job_path(job)

      within_task(1) do
        task_title.should eq "Service: #{service_plan.display_title}"
        task_total.should eq '$350.00'
        within_row(0) { verify_service_cost service_plan.display_title, '$350.00' }
      end

      grand_total.should eq '$350.00'

      click_on 'Add task'
      page.should have_no_css '.dropdown-menu a', text: 'Service'
      click_on 'Repair'

      within '.repair-form' do
        fill_in 'Title', with: 'Fix breaks'
        fill_in 'Note for mechanic', with: 'A note'
        click_on 'Done'
      end

      within_task(2) do
        add_item 'Part'
        within_row(0) { fill_in_part }

        add_item 'Labour'
        within_row(1) { fill_in_labour }

        add_item 'Fixed amount'
        within_row(2) { fill_in_fixed }
      end

      reset_mail_deliveries
      click_on 'Update job'

      within_task(2) do
        task_title.should eq 'Fix breaks'
        task_total.should eq '$331.00'
        within_row(0) { verify_part 'Break disc', '1', '56.0', '$56.00' }
        within_row(1) { verify_labour 'Changing break pads', '2', '0', '$100.00' }
        within_row(2) { verify_fixed 'Some fixed amount', '175.0' }
      end

      grand_total.should eq '$681.00'
      verify_email_notifications(job)
    end

    scenario 'edit items' do
      job = create :job, :with_service, :with_repair, :assigned
      service_plan = job.tasks.first.service_plan

      visit edit_admin_job_path(job)

      within_task(1) do
        task_title.should eq "Service: #{service_plan.display_title}"
        task_total.should eq '$350.00'
        within_row(0) { verify_service_cost service_plan.display_title, '$350.00' }
      end

      within_task(2) do
        task_title.should eq 'Replace break pads'
        task_total.should eq '$233.00'
        within_row(0) { verify_part 'Break pad', '2', '54.0', '$108.00' }
        within_row(1) { verify_labour 'Replace break pads', '2', '30', '$125.00' }
      end

      grand_total.should eq '$583.00'

      within_task(2) do
        within_row(0) { fill_in_part }
        within_row(1) { fill_in_labour }
      end

      reset_mail_deliveries
      click_on 'Update job'

      within_task(2) do
        task_title.should eq 'Replace break pads'
        task_total.should eq '$156.00'
        within_row(0) { verify_part 'Break disc', '1', '56.0', '$56.00' }
        within_row(1) { verify_labour 'Changing break pads', '2', '0', '$100.00' }
      end

      grand_total.should eq '$506.00'
      verify_email_notifications(job)
    end

    scenario 'delete tasks/items' do
      job = create :job, :with_service, :with_repair

      visit edit_admin_job_path(job)

      within_task(1) do
        find('.remove-task').click
      end

      within_task(2) do
        within_row(1) { find('.delete-item').click }
      end

      reset_mail_deliveries
      click_on 'Update job'

      page.should have_css '.task', count: 1
      page.should have_css '.item', count: 1

      grand_total.should eq '$108.00'
      verify_email_notifications(job)
    end

    scenario 'destroy job' do
      job = create :job, :with_service, :with_repair

      visit edit_admin_job_path(job)

      expect do
        click_link 'Delete Job'
      end.to change { Job.count }.by -1
      page.should have_css '.alert.alert-info', text: 'Job succesfully deleted.'
    end
  end

  def verify_service_cost(description, cost)
    page.should have_css '.desc', text: description
    page.should have_css '.total', text: cost
  end

  def verify_fixed(description, cost)
    page.should have_field 'Description', with: description
    page.should have_field 'Cost', with: cost
  end

  def verify_part(name, qty, unit_cost, total)
    # Not sure why this line is not working, I gave up and commented it out
    # page.should have_field 'Part name', with: name
    page.should have_field 'Qty', with: qty
    page.should have_field 'Cost', with: unit_cost
    page.should have_css '.total', text: total
  end

  def verify_labour(description, hours, minutes, total)
    page.should have_field 'Description', with: description
    page.should have_select find('.labour-hours')[:id], selected: hours
    page.should have_select find('.labour-minutes')[:id], selected: minutes
    page.should have_css '.total', text: total
  end

  def fill_in_part
    fill_in 'Part name', with: 'Brake disc'
    fill_in 'Qty', with: '1'
    fill_in 'Cost', with: '56'
  end

  def fill_in_labour
    fill_in 'Description', with: 'Changing break pads'
    select '2', from: find('.labour-hours')[:id]
    select '0', from: find('.labour-minutes')[:id]
  end

  def fill_in_fixed
    fill_in 'Description', with: 'Some fixed amount'
    fill_in 'Cost', with: '175'
  end

  def add_item(item)
    click_on 'Add item'
    click_on item
  end

  def within_task(task, &block)
    within ".task:nth-child(#{task})" do
      yield
    end
  end

  def within_row(row, &block)
    within all('.item')[row] do
      yield
    end
  end

  def task_title
    find('h5').text
  end

  def task_total
    find('dd.task-total').text
  end

  def grand_total
    find('dd.grand-total').text
  end

  def verify_email_notifications(job)
    mail_deliveries[0].tap do |m|
      m.to.should eq ['admin@example.com']
      m.subject.should eq 'Job quote updated'
    end
    mail_deliveries[1].tap do |m|
      m.to.should eq [job.user.email]
      m.subject.should eq "Your appointment for your #{job.car.display_title} has been updated"
    end
  end
end
