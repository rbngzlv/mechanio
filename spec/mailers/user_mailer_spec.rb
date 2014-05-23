require 'spec_helper'

describe UserMailer do
  let(:job)       { create :job, :assigned, :with_service, :with_event, mechanic: mechanic, user: user }
  let(:user)      { create :user, email: 'user@host.com', first_name: 'Buddy' }
  let(:mechanic)  { create :mechanic, first_name: 'Joe', last_name: 'Mechanic' }
  let(:to)        { ['user@host.com'] }
  let(:from)      { ['no-reply@mechanio.com'] }
  let(:car_title) { job.car.display_title }

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
    mail.subject.should   eq "We've got a quote for your #{car_title}"
    mail.body.encoded.should match edit_users_appointment_url(job)
  end

  specify '#estimate_followup' do
    mail = UserMailer.estimate_followup(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq "Can I help you with your #{car_title}?"
    mail.body.should match edit_users_appointment_url(job)
  end

  specify '#job_assigned' do
    mail = UserMailer.job_assigned(job.id)
    mail.to.should        eq [job.user.email]
    mail.from.should      eq from
    mail.subject.should   eq 'Your booking with Mechanio is confirmed'
    mail.body.encoded.should match "You're all set for an appointment with #{ job.mechanic.full_name }"
    mail.body.encoded.should match users_appointments_url
  end

  specify '#job_quote_changed' do
    mail = UserMailer.job_quote_changed(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq "Your appointment for your #{car_title} has been updated"
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
    mail.body.encoded.should have_content "Please click here to answer"
    mail.body.encoded.should match users_appointment_url(job)
  end
end
