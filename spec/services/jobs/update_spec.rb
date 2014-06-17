require 'spec_helper'

describe Jobs::Update do

  let(:service) { Jobs::Update.new }
  let(:user)    { create :user }

  it 'updates job' do
    job = create :job, :estimated, :with_service

    attrs = job_attributes
    attrs[:tasks_attributes][0][:id] = job.tasks[0].id

    job.cost.should eq 350
    job.final_cost.should eq 350

    service.should_receive(:notify_quote_changed)
    service.should_receive(:schedule_followup_email)

    service.call(job, job: attrs)

    job.tasks[0].reload.tap do |service|
      service.should be_a Service
      service.task_items[0].itemable.reload.cost.should eq 350
      service.cost.should eq 350
    end

    job.tasks[1].reload.tap do |repair|
      repair.should be_a Repair
      repair.task_items[0].itemable.reload.cost.should eq 125
      repair.task_items[1].itemable.reload.cost.should eq 108
      repair.task_items[2].itemable.reload.cost.should eq 100
      repair.cost.should eq 333
    end

    job.tasks[2].reload.tap do |inspection|
      inspection.should be_a Inspection
      inspection.title.should eq 'Break pedal vibration'
      inspection.cost.should eq 0
    end

    job.reload.cost.should eq 683
    job.final_cost.should eq 683
  end
end
