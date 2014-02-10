require 'spec_helper'

feature 'Jobs section' do
  before { login_admin }

  it 'is accessible from admin dashboard' do
    visit admins_dashboard_path

    click_link 'Jobs'

    current_path.should be_eql(admins_jobs_path)
  end

  context 'on index' do
    let!(:job1) { create :job_with_service }
    let!(:job2) { create :assigned_job, location: create(:location, :with_coordinates) }

    before { visit admins_jobs_path }

    subject { page }

    scenario 'shows header and rows' do
      should have_css 'thead', text: 'ID Status Job Requested by Allocated to Location Cost'

      within 'tbody' do
        within('tr:nth-child(1)') { verify_job_row job2 }
        within('tr:nth-child(2)') { verify_job_row job1 }
      end
    end

    specify 'filters by status', :js do

      select 'Estimated', from: 'status'

      verify_job_row job1
      page.should have_css 'tbody tr', count: 1
      page.should have_field 'status', with: 'estimated'

      select 'All', from: 'status'

      verify_job_row job1
      verify_job_row job2
      page.should have_css 'tbody tr', count: 2
      page.should have_field 'status', with: ''
    end
  end

  context 'editing a job', :js do
    scenario 'general info tab' do
      job = create :job, :with_service, :estimated, :assigned

      visit edit_admins_job_path(job)

      page.should have_css 'li.active a', text: 'General info'

      page.should have_css '.label', text: 'Assigned'
      page.should have_content "ID: #{job.uid}"
      page.should have_content job.client_name
      page.should have_content job.mechanic.full_name
      page.should have_content job.car.display_title
      page.should have_content'Last service: 10000 Km'

      page.should have_field 'job_contact_email', with: job.contact_email
      page.should have_field 'job_contact_phone', with: job.contact_phone
    end

    context 'items tab' do
      scenario 'add service' do
        job = create :job, :with_repair
        service_plan = create :service_plan, model_variation: job.car.model_variation

        visit_job_items(job)

        within_task(1) { verify_repair }

        grand_total.should eq '$333.00'

        click_on 'Add service'

        within('.service-form') { fill_in_service(service_plan) }

        before_and_after_save(job) do
          within_task(2) { verify_service(service_plan) }

          grand_total.should eq '$683.00'
        end


        add_service_link[:disabled].should be_true
      end

      scenario 'add repair' do
        job = create :job, :with_service
        service_plan = job.tasks.first.service_plan

        visit_job_items(job)

        within_task(1) { verify_service(service_plan) }

        grand_total.should eq '$350.00'

        add_service_link[:disabled].should be_true

        click_on 'Add repair'

        within('.repair-form') { fill_in_repair }

        within_task(2) do
          click_on 'Add parts'
          within_row(0) { fill_in_part }

          click_on 'Add labour'
          within_row(1) { fill_in_labour }

          click_on 'Add amount'
          within_row(2) { fill_in_fixed }
        end

        before_and_after_save job do
          within_task(2) { verify_edited_repair }

          grand_total.should eq '$681.00'
        end
      end

      scenario 'job with inspection' do
        job = create :job, :with_inspection

        visit_job_items(job)

        within_task(1) { verify_inspection }

        grand_total.should eq '$80.00'
      end

      scenario 'edit items' do
        job = create :job, :with_service, :with_repair, :with_inspection
        service_plan = job.tasks.first.service_plan
        another_service_plan = create(:service_plan, model_variation: job.car.model_variation)

        visit_job_items(job)

        within_task(1) { verify_service(service_plan) }
        within_task(2) { verify_repair }
        within_task(3) { verify_inspection }

        grand_total.should eq '$763.00'

        within_task(1) do
          click_link 'Edit'
          fill_in_service(another_service_plan)
        end

        within_task(2) do
          click_link 'Edit'
          fill_in_repair
          within_row(0) { fill_in_part }
          within_row(1) { fill_in_labour }
          within_row(2) { fill_in_fixed }
        end

        within_task(3) do
          click_link 'Edit'
          fill_in_inspection 'Edited title', 'Edited notes'
        end

        before_and_after_save job do
          within_task(1) do
            verify_service(another_service_plan)
          end

          within_task(2) do
            verify_edited_repair
          end

          within_task(3) do
            verify_inspection 'Edited title', 'Edited notes'
          end

          grand_total.should eq '$761.00'
        end
      end

      scenario 'delete tasks/items' do
        job = create :job, :with_service, :with_repair

        visit_job_items(job)

        within_task(1) do
          find('.remove-task').click
        end

        within_task(2) do
          within_row(1) { find('.delete-item').click }
        end

        before_and_after_save job do
          page.should have_css '.task', count: 1
          page.should have_css '.item', count: 2
  
          grand_total.should eq '$208.00'
        end
      end

      scenario 'delete job' do
        job = create :job, :with_service

        visit edit_admins_job_path(job)

        expect { click_link 'Delete Job' }.to change { Job.count }.by -1
        page.should have_css '.alert.alert-info', text: 'Job succesfully deleted.'
      end
    end
  end


  def verify_job_row(job)
    should have_content job.uid
    should have_content job.status.capitalize
    should have_content "#{job.location.suburb}, #{job.location.postcode}"
    should have_content job.title
    should have_content job.created_at.to_s(:date)
    should have_content job.client_name
    should have_content job.scheduled_at? ? job.scheduled_at.to_s(:date_time) : ''
    should have_content job.mechanic ? job.mechanic.full_name : 'unassigned'
    should have_content job.cost
    should have_link "Edit"
  end

  def visit_job_items(job)
    visit edit_admins_job_path(job)
    open_items_tab
  end

  def open_items_tab
    click_on 'Job and labour'
    page.should have_css 'li.active a', text: 'Job and labour'
  end

  def save_changes
    reset_mail_deliveries
    click_on 'Save Changes'
    open_items_tab
  end

  def before_and_after_save(job, &block)
    block.call
    save_changes
    verify_email_notifications(job)
    block.call
  end

  def verify_service(service_plan)
    task_title.should eq "#{service_plan.display_title} service"
    task_total.should eq '$350.00'
    within_row(0) { verify_service_cost service_plan.display_title, '$350.00' }
  end

  def fill_in_repair
    fill_in 'Repair description', with: 'Edited repair'
    fill_in 'Notes', with: 'Edited note'
    click_on 'Done'
  end

  def verify_edited_repair
    task_title.should eq 'Edited repair'
    task_total.should eq '$331.00'
    verify_edited_items
  end

  def verify_repair
    task_title.should eq 'Replace break pads'
    task_total.should eq '$333.00'
    within_row(0) { verify_part 'Break pad', '2', '54.0', '$108.00' }
    within_row(1) { verify_labour '02 h', '30 m', '$125.00' }
    within_row(2) { verify_fixed 'Fixed amount', '100.0' }
  end

  def fill_in_inspection(title, notes)
    fill_in 'Inspection description', with: title
    fill_in 'Notes', with: notes
    click_on 'Done'
  end

  def verify_inspection(title = nil, notes = nil)
    task_title.should eq title || 'Break pedal vibration'
    page.should have_css '.panel-body', text: notes || 'Notes: A note to mechanic Cost $80.00'
  end

  def verify_service_cost(description, cost)
    page.should have_css '.desc', text: description
    page.should have_css '.total', text: cost
  end

  def verify_part(name, qty, unit_cost, total)
    page.should have_field 'Part name', with: name
    page.should have_field 'Qty', with: qty
    page.should have_field 'Cost', with: unit_cost
    page.should have_css '.total', text: total
  end

  def verify_labour(hours, minutes, total)
    page.should have_css '.desc', text: 'Labour'
    page.should have_css '.hourly-rate', text: '$50.00'
    page.should have_select find('.labour-hours')[:id], selected: hours
    page.should have_select find('.labour-minutes')[:id], selected: minutes
    page.should have_css '.total', text: total
  end

  def fill_in_service(service_plan)
    select service_plan.display_title, from: find('.job_tasks_service_plan_id select')[:id]
    fill_in 'Notes', with: 'Edited note'
    click_on 'Done'
  end

  def fill_in_part
    fill_in 'Part name', with: 'Edited part'
    fill_in 'Qty', with: '1'
    fill_in 'Cost', with: '56.0'
  end

  def fill_in_labour
    select '02 h', from: find('.labour-hours')[:id]
    select '00 m', from: find('.labour-minutes')[:id]
  end

  def fill_in_fixed
    fill_in 'Charge description', with: 'Some fixed amount'
    fill_in 'Cost', with: '175.0'
  end

  def verify_edited_items
    within_row(0) { verify_part 'Edited part', '1', '56.0', '$56.00' }
    within_row(1) { verify_labour '02 h', '00 m', '$100.00' }
    within_row(2) { verify_fixed 'Some fixed amount', '175.0' }
  end

  def verify_fixed(description, cost)
    page.should have_field 'Charge description', with: description
    page.should have_field 'Cost', with: cost
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
    find('.grand-total dd').text
  end

  def add_service_link
    page.find_link('Add service')
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
