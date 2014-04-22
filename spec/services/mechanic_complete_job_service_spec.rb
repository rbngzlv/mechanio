require 'spec_helper'

describe MechanicCompleteJobService do

  let(:job)     { create :job, :with_service, :assigned }
  let(:service) { MechanicCompleteJobService.new(job) }

  describe '#complete' do

    before { reset_mail_deliveries }

    specify 'success' do
      job.completed_at.should be_nil

      service.perform

      job.reload.completed_at.should_not be_nil
      job.status.should eq 'completed'
      job.mechanic.completed_jobs_count.should eq 1

      mail_deliveries.count.should eq 3
    end
  end
end
