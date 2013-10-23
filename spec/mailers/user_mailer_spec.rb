require 'spec_helper'

describe UserMailer do
  let(:job)  { build :job, id: 123 }
  let(:to)   { [job.user.email] }
  let(:from) { ['no-reply@mechanio.com'] }

  specify '#job_pending' do
    mail = UserMailer.job_pending(job)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq 'Quote requested'
    mail.body.encoded.should match users_estimates_url
  end

  specify '#job_estimated' do
    mail = UserMailer.job_estimated(job)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq 'Job quote'
    mail.body.encoded.should match users_estimates_url
  end

  specify '#job_assigned' do
    mail = UserMailer.job_assigned(job)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq 'Job assigned'
    mail.body.encoded.should match users_estimates_url
  end

  specify '#job_quote_changed' do
    mail = UserMailer.job_quote_changed(job)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq 'Job quote updated'
    mail.body.encoded.should match users_estimates_url
  end
end
