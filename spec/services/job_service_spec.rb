require 'spec_helper'

describe JobService do

  let(:job) { create :job, :with_service, :assigned }
  let(:job_service) { JobService.new(job) }

  describe '#complete' do

    before { reset_mail_deliveries }

    specify 'success' do
      job.completed_at.should be_nil

      job_service.complete

      job.completed_at.should_not be_nil
      job.status.should eq 'completed'
      job.mechanic.completed_jobs_count.should eq 1

      mail_deliveries.count.should eq 2
    end
  end
end
