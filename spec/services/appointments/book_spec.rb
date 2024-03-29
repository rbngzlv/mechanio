require 'spec_helper'

describe Appointments::Book do

  let(:job)          { build_stubbed :job, :with_service, :with_credit_card, :estimated }
  let(:mechanic)     { build_stubbed :mechanic }
  let(:scheduled_at) { Date.tomorrow + 10.hours }
  let(:service)      { Appointments::Book.new(job, mechanic, scheduled_at) }

  it { service.should be_valid }

  describe 'validations' do
    context 'scheduled_at is before tomorrow' do
      let(:scheduled_at) { DateTime.now.in_time_zone }

      it { service.should_not be_valid }
    end

    context 'mechanic is unavailable' do
      before do
        event = build :event, start_time: scheduled_at, end_time: scheduled_at + 2.hours, job: job
        event.build_schedule

        mechanic.stub(:events).and_return([event])
      end

      it { service.should_not be_valid }
    end

    context 'job already assigned' do
      before do
        job.stub(:appointment).and_return(build_stubbed :appointment)
      end

      it { service.should_not be_valid }
    end
  end

  context 'appointment valid' do
    let(:job) { create :job, :with_service, :with_credit_card, :estimated }
    let(:mechanic) { create :mechanic }

    before { reset_mail_deliveries }

    it 'books appointment with mechanic' do
      service.call.should be_true

      job.assigned_at.should_not  be_nil
      job.status.should           eq 'assigned'
      job.scheduled_at.should     eq scheduled_at
      job.event.start_time.should eq scheduled_at
      job.event.should            eq mechanic.reload.events.last
      mechanic.current_jobs_count.should eq 1

      mail_deliveries.count.should eq 3
    end
  end

  context 'appointment invalid' do
    let(:scheduled_at) { DateTime.now.in_time_zone }

    before { reset_mail_deliveries }

    it 'does not book appointment' do
      service.call.should be_false

      job.status.should           eq 'estimated'
      job.assigned_at.should      be_nil
      job.scheduled_at.should     be_nil
      job.event.should            be_nil
      mechanic.current_jobs_count.should eq 0

      mail_deliveries.count.should eq 0
    end
  end
end
