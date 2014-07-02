require 'spec_helper'

describe Jobs::Create do

  let(:service)         { Jobs::Create.new }
  let(:user)            { create :user }

  it 'creates estimated job' do
    # service.should_receive(:notify_estimated)
    service.should_receive(:schedule_followup_email)

    job = service.call(user, job: job_attributes).reload

    job.status.should             eq 'estimated'
    job.user_id.should            eq user.id
    job.serialized_params.should  be_nil

    job.tasks[0].reload.tap do |service|
      service.task_items[0].itemable.reload.cost.should eq 350
      service.cost.should eq 350
    end

    job.tasks[1].reload.tap do |repair|
      repair.task_items[0].itemable.reload.cost.should eq 125
      repair.task_items[1].itemable.reload.cost.should eq 108
      repair.task_items[2].itemable.reload.cost.should eq 100
      repair.cost.should eq 333
    end

    job.tasks[2].reload.cost.should eq 0

    job.cost.should                 eq 683
  end

  it 'creates pending job' do
    service.should_receive(:notify_pending)
    service.should_not_receive(:schedule_followup_email)

    job = service.call(user, job: pending_job_attributes).reload

    job.status.should             eq 'pending'
    job.user_id.should            eq user.id
    job.serialized_params.should  be_nil
    job.cost.should               eq nil
  end

  it 'creates temporary job' do
    job = service.call(nil, job: job_attributes).reload

    job.status.should eq 'temporary'
    job.user_id.should be_nil
    job.serialized_params.should_not be_nil
  end

  it 'raises exception when temporary job is invalid' do
    expect { service.call(nil, job: invalid_job_attributes) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
