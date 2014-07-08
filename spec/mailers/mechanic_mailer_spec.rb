require 'spec_helper'

describe MechanicMailer do
  let(:mechanic) { create :mechanic }
  let(:job)      { create :job, :with_service, :assigned, mechanic: mechanic }
  let(:to)       { [mechanic.email] }
  let(:from) { ['no-reply@mechanio.com'] }

  specify '#registration_note' do
    mail = MechanicMailer.registration_note(mechanic.id, 'password')
    mail.to.should eq to
    mail.from.should eq from
    mail.subject.should eq 'Welcome to Mechanio Family!'
    mail.body.encoded.should match mechanic.email
    mail.body.encoded.should match 'Password: password'
    mail.body.encoded.should match new_mechanic_session_url
  end

  specify '#job_assigned' do
    mail = MechanicMailer.job_assigned(job.id)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq 'Congratulations, you\'ve been scheduled a job.'
    mail.body.encoded.should match mechanics_job_url(job)
  end
end
