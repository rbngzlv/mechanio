require 'spec_helper'

feature 'Edit job', :js do
  before { login_admin }

  let(:job)           { create :job, :with_service, :assigned, mechanic: mechanic }
  let(:payout_method) { create :payout_method, account_name: 'Some bank', account_number: '99988881', bsb_number: '987654' }
  let(:mechanic)      { create :mechanic, payout_method: payout_method }
  let(:receipt_path)  { "#{Rails.root}/spec/fixtures/test_img.jpg" }

  scenario 'general info tab' do
    visit edit_admins_job_path(job)

    page.should have_css 'li.active a', text: 'General info'

    page.should have_css '.label', text: 'Assigned'
    page.should have_content "ID: #{job.uid}"
    page.should have_content job.client_name
    page.should have_content job.mechanic.full_name
    page.should have_content job.car.display_title
    page.should have_content'Last service: 10000 Km'

    page.should have_field 'Address',  with: 'Palm beach 55'
    page.should have_field 'Suburb',   with: 'Sydney, NSW 2012'

    page.should have_field 'job_contact_email', with: job.contact_email
    page.should have_field 'job_contact_phone', with: job.contact_phone
  end

  context 'feedback tab' do
    let(:job)     { create :job, :completed, :with_service }
    let(:rating)  { create :rating, job: job, mechanic: job.mechanic, user: job.user, recommend: false }
    let(:radio)   { find('#rating_recommend_true') }

    before do
      rating
      visit edit_admins_job_path(job)
      within('.nav-tabs') { click_on 'Feedback' }
    end

    scenario 'edits rating' do
      page.should have_content 'LEAVE FEEDBACK'
      within '.rating_recommend' do
        radio.checked?.should be_false
        radio.click
      end

      click_on 'Save'

      within('.nav-tabs') { click_on 'Feedback' }
      radio.checked?.should be_true
    end
  end

  context 'items tab' do
    scenario 'add service' do
      job = create :job, :with_repair, :with_inspection
      service_plan = create :service_plan, model_variation: job.car.model_variation

      visit_job_items(job)

      within_task(1) { verify_repair }
      within_task(2) { verify_inspection }

      grand_total.should eq '$413.00'

      click_on 'Add service'

      within('.service-form') { fill_in_service(service_plan) }

      before_and_after_save(job) do
        within_task(1) { verify_repair }
        within_task(2) { verify_inspection 'included' }
        within_task(3) { verify_service(service_plan.display_title, service_plan.cost) }

        grand_total.should eq '$683.00'
      end

      add_service_link[:disabled].should be_true
    end

    scenario 'add repair' do
      job = create :job, :with_service
      service_plan = job.tasks.first.service_plan

      visit_job_items(job)

      within_task(1) { verify_service(service_plan.display_title, service_plan.cost) }

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

    scenario 'job with discount' do
      job = create :job, :with_inspection, :with_discount

      visit_job_items(job)

      within_task(1) { verify_inspection }

      find('.grand-total:nth-child(1)').text.should eq '20% off discount $16.00'
      find('.grand-total:nth-child(2)').text.should eq 'Job total $64.00'

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

        find('.grand-total:nth-child(1)').text.should eq '20% off discount $82.20'
        find('.grand-total:nth-child(2)').text.should eq 'Job total $328.80'
      end
    end

    scenario 'job with multiple inspections' do
      job = create :job, tasks: [create(:inspection), create(:inspection)]

      visit_job_items(job)

      within_task(1) { verify_inspection }
      within_task(2) { verify_inspection 'included' }

      grand_total.should eq '$80.00'
    end

    scenario 'edit items' do
      job = create :job, :with_service, :with_repair, :with_inspection
      service_plan = job.tasks.first.service_plan
      another_service_plan = create(:service_plan, model_variation: job.car.model_variation, cost: 250)

      visit_job_items(job)

      within_task(1) { verify_service(service_plan.display_title, service_plan.cost) }
      within_task(2) { verify_repair }
      within_task(3) { verify_inspection 'included' }

      grand_total.should eq '$683.00'

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
          verify_service(another_service_plan.display_title, another_service_plan.cost)
        end

        within_task(2) do
          verify_edited_repair
        end

        within_task(3) do
          verify_inspection 'included', 'Edited title', 'Edited notes'
        end

        grand_total.should eq '$581.00'
      end
    end

    scenario 'edit service cost' do
      job = create :job, :with_service
      service_plan = job.tasks.first.service_plan

      visit_job_items(job)

      within_task(1) { verify_service_cost('350.0') }

      grand_total.should eq '$350.00'

      within_task(1) do
        fill_in 'Cost', with: '200.0'
      end

      before_and_after_save job do
        within_task(1) { verify_service_cost('200.0') }
        grand_total.should eq '$200.00'
      end
    end

    scenario 'add negative amount' do
      job = create :job, :with_service

      visit_job_items(job)

      within_task(1) { verify_service_cost('350.0') }

      grand_total.should eq '$350.00'

      page.should_not have_css '.save-warning'

      within_task(1) do
        click_on 'Add amount'
      end

      within_row(1) do
        fill_in 'Charge description', with: 'Some fixed amount'
        fill_in 'Cost', with: '-2000.0'
      end

      page.should have_css '.save-warning'
      page.should have_button('Save Changes', disabled: true)

      within_row(1) do
        fill_in 'Charge description', with: 'Some fixed amount'
        fill_in 'Cost', with: '-20.0'
      end

      before_and_after_save job do
        within_task(1) { verify_service_cost('350.0') }
        within_row(1) do
          verify_fixed('Some fixed amount', '-20.0')
        end
        grand_total.should eq '$330.00'
      end
    end

    scenario 'delete tasks/items' do
      job = create :job, :with_service, :with_repair, :with_inspection
      service_plan = job.tasks.first.service_plan

      visit_job_items(job)

      within_task(1) { verify_service(service_plan.display_title, service_plan.cost) }
      within_task(2) { verify_repair }
      within_task(3) { verify_inspection 'included' }
      grand_total.should eq '$683.00'

      within_task(1) do
        find('.remove-task').click
      end

      find_task 1, visible: false
      within_task(2) { verify_repair }
      within_task(3) { verify_inspection }
      grand_total.should eq '$413.00'

      within_task(2) do
        within_row(1) { find('.delete-item').click }
      end

      before_and_after_save job do
        page.should have_css '.task', count: 2
        page.should have_css '.item', count: 2

        grand_total.should eq '$288.00'
      end
    end

    scenario 'complete job' do
      job = create :job, :with_service, :assigned, scheduled_at: DateTime.yesterday
      reset_mail_deliveries

      visit edit_admins_job_path(job)

      click_on 'Complete Job'

      page.should have_css '.alert.alert-info', text: 'Job successfully completed'
      page.should have_css '.label', text: 'Completed'
    end

    scenario 'cancel job' do
      job = create :job, :with_service, :estimated
      reset_mail_deliveries

      visit edit_admins_job_path(job)

      click_on 'Cancel Job'

      page.should have_css '.alert.alert-info', text: 'Job successfully cancelled'
      page.should have_css '.label', text: 'Cancelled'
    end
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

  def verify_service(title, cost)
    task_title.should eq "#{title} service"
    task_total.should eq formatted_cost(cost)
    within_row(0) { verify_service_cost(cost) }
  end

  def fill_in_repair
    fill_in 'Repair description', with: 'Edited repair'
    fill_in 'Notes', with: 'Edited note'
    click_on 'Done'
  end

  def verify_edited_repair
    task_title.should eq 'Edited repair'
    task_total.should eq '$331.00'
    within_row(0) { verify_part 'Edited part', '1', '56.0', '$56.00' }
    within_row(1) { verify_labour '02 h', '00 m', '$100.00' }
    within_row(2) { verify_fixed 'Some fixed amount', '175.0' }
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

  def verify_inspection(amount = nil, title = nil, notes = nil)
    task_title.should eq title || 'Break pedal vibration'
    amount ||= '$80'
    page.should have_css '.panel-body', text: notes || "Notes: A note to mechanic Cost #{amount}"
  end

  def verify_service_cost(cost)
    page.should have_field 'Service cost', disabled: true
    page.should have_field 'Cost', with: cost.to_s
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

  def verify_fixed(description, cost)
    page.should have_field 'Charge description', with: description
    page.should have_field 'Cost', with: cost
  end

  def find_task(index, options = {})
    find ".task:nth-child(#{index})", options
  end

  def within_task(index, &block)
    within find_task(index) do
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
