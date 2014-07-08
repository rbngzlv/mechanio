require 'spec_helper'

describe Jobs::Complete do

  let(:job)         { create :job, :with_service, :assigned, scheduled_at: DateTime.yesterday, user: user }
  let(:another_job) { create :job, :with_service, :completed, user: user }
  let(:user)        { create :user }
  let(:service)     { Jobs::Complete.new(job) }

  describe '#complete' do

    before { reset_mail_deliveries }

    context 'first job - send thank you email' do
      specify 'success' do
        job.completed_at.should be_nil

        service.call

        job.reload.completed_at.should_not be_nil
        job.status.should eq 'completed'
        job.mechanic.completed_jobs_count.should eq 1

        verify_emails_sent({
          "How did #{job.mechanic.first_name} go?" => job.user.email,
          "Thanks for your first appointment with us. We hope it was memorable!" => job.user.email,
          "Your Mechanio Receipt is now ready to view" => job.user.email,
          "Job #{job.uid} has been completed" => ["admin@example.com"]
        })
      end
    end

    context 'second job - do not send thank you email' do
      before do
        another_job
      end

      specify 'success' do
        job.completed_at.should be_nil

        service.call

        job.reload.completed_at.should_not be_nil
        job.status.should eq 'completed'
        job.mechanic.completed_jobs_count.should eq 1

        verify_emails_sent({
          "How did #{job.mechanic.first_name} go?" => job.user.email,
          "Your Mechanio Receipt is now ready to view" => job.user.email,
          "Job #{job.uid} has been completed" => ["admin@example.com"]
        })
      end
    end
  end
end
