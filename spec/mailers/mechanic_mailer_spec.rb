require 'spec_helper'

describe MechanicMailer do
  let(:mechanic) { build :mechanic }
  let(:job)      { build :job, mechanic: mechanic, id: 123 }
  let(:to)       { [mechanic.email] }
  let(:from) { ['no-reply@mechanio.com'] }

  specify '#registration_note' do
    mail = MechanicMailer.registration_note(mechanic)
    mail.to.should eq to
    mail.from.should eq from
    mail.subject.should eq 'Welcome to Mechanio'
    mail.body.encoded.should match mechanic.email
    mail.body.encoded.should match mechanic.password
    mail.body.encoded.should match new_mechanic_session_url
  end

  specify '#job_assigned' do
    mail = MechanicMailer.job_assigned(job)
    mail.to.should        eq to
    mail.from.should      eq from
    mail.subject.should   eq 'You got a new job'
    mail.body.encoded.should match mechanics_dashboard_url
  end
end
