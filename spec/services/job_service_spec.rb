require 'spec_helper'

describe JobService do

  let(:service)         { JobService.new }
  let(:user)            { create :user }
  let(:temporary_job)   { create_temporary_job }

  describe '#create_job' do
    it 'creates estimated job' do
      service.should_receive(:notify_estimated)

      job = service.create_job(user, job: job_attributes).reload

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

      job = service.create_job(user, job: pending_job_attributes).reload

      job.status.should             eq 'pending'
      job.user_id.should            eq user.id
      job.serialized_params.should  be_nil
      job.cost.should               eq nil
    end

    it 'creates temporary job' do
      job = service.create_job(nil, job: job_attributes).reload

      job.status.should eq 'temporary'
      job.user_id.should be_nil
      job.serialized_params.should_not be_nil
    end

    it 'raises exception when temporary job is invalid' do
      expect { service.create_job(nil, job: invalid_job_attributes) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  specify '#update_job' do
    job = create :job, :estimated, :with_service

    attrs = job_attributes
    attrs[:tasks_attributes][0][:id] = job.tasks[0].id

    job.cost.should eq 350

    service.should_receive(:notify_quote_changed)

    service.update_job(job, job: attrs)

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

    job.cost.should eq 683
  end

  specify '#convert_from_temporary' do
    service.should_receive(:notify_estimated)

    job = service.convert_from_temporary(temporary_job.id, user).reload

    job.id.should         eq temporary_job.id
    job.status.should     eq 'estimated'
    job.user_id.should    eq user.id
    job.cost.should       eq 683
  end
end
