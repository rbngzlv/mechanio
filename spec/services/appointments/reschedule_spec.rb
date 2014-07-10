require 'spec_helper'

describe Appointments::Reschedule do

  let!(:job)          { create :job, :with_service, :with_credit_card, :assigned, mechanic: mechanic, scheduled_at: previous_date }
  let(:mechanic)      { create :mechanic }
  let(:previous_date) { Date.tomorrow.in_time_zone }
  let(:scheduled_at)  { Date.tomorrow + 10.hours }
  let(:service)       { Appointments::Reschedule.new(job, scheduled_at) }

  it { service.should be_valid }

  describe 'validations' do
    context 'scheduled_at is before tomorrow' do
      let(:scheduled_at) { Date.today.in_time_zone }

      it { service.should_not be_valid }
    end

    context 'mechanic is unavailable' do
      let(:scheduled_at) { Date.tomorrow.in_time_zone }

      it { mechanic.events.reload; service.should_not be_valid }
    end
  end

  context 'success' do
    before { reset_mail_deliveries }

    it 'reschedules appointment' do
      service.call.should be_true

      job.status.should           eq 'assigned'
      job.scheduled_at.should     eq scheduled_at
      job.event.start_time.should eq scheduled_at

      # mail_deliveries.count.should eq 3
    end
  end

  context 'appointment invalid' do
    let(:scheduled_at) { Date.today.in_time_zone }

    before { reset_mail_deliveries }

    it 'does not book appointment' do
      service.call.should be_false

      job.status.should           eq 'assigned'
      job.scheduled_at.should     eq previous_date

      mail_deliveries.count.should eq 0
    end
  end
end
