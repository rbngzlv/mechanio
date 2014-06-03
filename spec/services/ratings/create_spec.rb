require 'spec_helper'

describe Ratings::Create do

  let(:service)   { Ratings::Create.new(user, job) }
  let(:user)      { create :user }
  let(:mechanic)  { create :mechanic }
  let(:job)       { create :job, :with_service, mechanic: mechanic }
  let(:rating)    { create :rating, job: job, mechanic: mechanic, user: user }
  let(:attrs)     { { professional: 2, service_quality: 3, communication: 2, cleanness: 5, convenience: 5 } }

  it 'returns a Rating object associated with job, user and mechanic' do
    rating = service.call(attrs)

    rating.should             be_a Rating
    rating.job_id.should      eq job.id
    rating.user_id.should     eq user.id
    rating.mechanic_id.should eq mechanic.id
  end

  it 'updates mechanics average rating' do
    service.call(attrs)

    mechanic.rating.should eq 3.4
  end

  it 'does not rate a job that already rated' do
    job.rating = rating

    service.call(attrs).should be_false

    job.reload.rating.should eq rating
  end

  it 'returns false on failure' do
    invalid_attrs = attrs
    invalid_attrs.delete(:professional)

    service.call(invalid_attrs).should be_false
  end
end
