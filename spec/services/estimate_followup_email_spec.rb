require 'spec_helper'

describe EstimateFollowupEmailService do

  # let(:service) { EstimateFollowupEmailService.new }

  before { reset_mail_deliveries }

  context 'estimated job' do
    let(:job) { create :job, :estimated, :with_service }

    it 'sends a followup email' do
      expect { subject.perform(job.id) }.to change { mail_deliveries.count }.from(0).to(1)
    end
  end

  context 'assigned job' do
    let(:job) { create :job, :assigned, :with_service }

    it 'does not send an email' do
      expect { subject.perform(job.id) }.to_not change { mail_deliveries.count }.from(0)
    end
  end
end
