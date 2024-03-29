require 'spec_helper'

describe AdminMailer do
  let(:job)  { create :job, :with_service }
  let(:to)   { ['admin@example.com'] }
  let(:from) { ['no-reply@mechanio.com'] }

  specify '#job_pending' do
    mail = AdminMailer.job_pending(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq 'New pending job'
    mail.body.encoded.should match edit_admins_job_url(job.id)
  end

  specify '#job_estimated' do
    mail = AdminMailer.job_estimated(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq 'Job estimated'
    mail.body.encoded.should match edit_admins_job_url(job.id)
  end

  specify '#job_assigned' do
    mail = AdminMailer.job_assigned(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq 'Job assigned'
    mail.body.encoded.should match edit_admins_job_url(job.id)
  end

  specify '#job_quote_changed' do
    mail = AdminMailer.job_quote_changed(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq 'Job quote updated'
    mail.body.encoded.should match edit_admins_job_url(job.id)
  end

  specify '#job_completed' do
    mail = AdminMailer.job_completed(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq "Job #{job.uid} has been completed"
    mail.body.encoded.should match edit_admins_job_url(job.id)
  end

  specify '#estimate_deleted' do
    mail = AdminMailer.estimate_deleted(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq "A customer has deleted an estimate"
    mail.body.encoded.should match edit_admins_job_url(job.id)
  end

  specify '#payment_error' do
    mail = AdminMailer.payment_error(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq "Error processing payment for job #{job.uid}"
    mail.body.encoded.should match edit_admins_job_url(job.id)
  end

  specify '#payment_success' do
    mail = AdminMailer.payment_success(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq "Payment for job #{job.uid} processed succesfully"
    mail.body.encoded.should match edit_admins_job_url(job.id)
  end
end
