require 'spec_helper'

describe AdminMailer do
  let(:job) { build :job, id: 123 }

  specify '#job_pending' do
    mail = AdminMailer.job_pending(job)
    mail.to.should        eq ['admin@example.com']
    mail.from.should      eq ['no-reply@mechanio.com']
    mail.subject.should   eq 'New pending job'
    mail.body.encoded.should match edit_admin_job_path(job.id)
  end

  specify '#job_estimated' do
    mail = AdminMailer.job_estimated(job)
    mail.to.should        eq ['admin@example.com']
    mail.from.should      eq ['no-reply@mechanio.com']
    mail.subject.should   eq 'Job estimated'
    mail.body.encoded.should match edit_admin_job_path(job.id)
  end

  specify '#job_assigned' do
    mail = AdminMailer.job_assigned(job)
    mail.to.should        eq ['admin@example.com']
    mail.from.should      eq ['no-reply@mechanio.com']
    mail.subject.should   eq 'Job assigned'
    mail.body.encoded.should match edit_admin_job_path(job.id)
  end

  specify '#job_quote_changed' do
    mail = AdminMailer.job_quote_changed(job)
    mail.to.should        eq ['admin@example.com']
    mail.from.should      eq ['no-reply@mechanio.com']
    mail.subject.should   eq 'Job quote updated'
    mail.body.encoded.should match edit_admin_job_path(job.id)
  end
end
