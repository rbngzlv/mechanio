require 'spec_helper'

describe UserMailer do
  let(:job)  { build :job, id: 123 }
  let(:to)   { [job.user.email] }
  let(:from) { ['no-reply@mechanio.com'] }

  specify '#job_pending' do
    mail = UserMailer.job_pending(job)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq 'Thanks for requesting a quote'
  end

  specify '#job_estimated' do
    mail = UserMailer.job_estimated(job)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq "We've got a quote for your #{job.car.display_title}"
    mail.body.encoded.should match edit_users_appointment_url(job)
  end

  specify '#job_assigned' do
    job.mechanic = build :mechanic
    build(:event, :job, job: job)
    mail = UserMailer.job_assigned(job)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq 'Your booking with Mechanio is confirmed'
    mail.body.encoded.should match users_appointments_url
  end

  specify '#job_quote_changed' do
    mail = UserMailer.job_quote_changed(job)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq "Your appointment for your #{job.car.display_title} has been updated"
    mail.body.encoded.should match users_estimates_url
  end
end
