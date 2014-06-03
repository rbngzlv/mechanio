require 'spec_helper'

describe Jobs::Convert do

  let(:service)         { Jobs::Convert.new }
  let(:user)            { create :user }
  let(:temporary_job)   { create_temporary_job }

  specify 'converts from temporary' do
    service.should_receive(:notify_estimated)
    service.should_receive(:schedule_followup_email)

    job = service.call(temporary_job.id, user).reload

    job.id.should         eq temporary_job.id
    job.status.should     eq 'estimated'
    job.user_id.should    eq user.id
    job.cost.should       eq 683
  end
end
