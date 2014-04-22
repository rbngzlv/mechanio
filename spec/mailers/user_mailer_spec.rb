require 'spec_helper'

describe UserMailer do
  let(:job)  { create :job, :assigned, :with_service, :with_event, mechanic: mechanic }
  let(:mechanic)  { create :mechanic, first_name: 'Joe', last_name: 'Mechanic' }
  let(:to)   { [job.user.email] }
  let(:from) { ['no-reply@mechanio.com'] }

  specify '#job_pending' do
    mail = UserMailer.job_pending(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq 'Thanks for requesting a quote'
  end

  specify '#job_estimated' do
    mail = UserMailer.job_estimated(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq "We've got a quote for your #{job.car.display_title}"
    mail.body.encoded.should match edit_users_appointment_url(job)
  end

  specify '#job_assigned' do
    mail = UserMailer.job_assigned(job.id)
    mail.to.should        eq [job.user.email]
    mail.from.should      eq from
    mail.subject.should   eq 'Your booking with Mechanio is confirmed'
    mail.body.encoded.should match users_appointments_url
    mail.body.encoded.should match "ID: #{job.uid}"
  end

  specify '#job_quote_changed' do
    mail = UserMailer.job_quote_changed(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq "Your appointment for your #{job.car.display_title} has been updated"
    mail.body.encoded.should match users_estimates_url
  end

  specify '#job_completed' do
    mail = UserMailer.job_completed(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq "Your Mechanio Receipt is now ready to view"
    mail.body.encoded.should have_content "Please see the receipt attached"
  end

  specify '#leave_feedback' do
    mail = UserMailer.leave_feedback(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq "How did Joe Mechanic go?"
    mail.body.encoded.should have_content "Click here to leave your feedback"
  end
end
