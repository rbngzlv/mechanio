require 'spec_helper'

describe RatingService do

  let(:service)   { RatingService.new(user, job) }
  let(:user)      { create :user }
  let(:mechanic)  { create :mechanic }
  let(:job)       { create :job, :with_service, mechanic: mechanic }
  let(:attrs)     { { professional: 2, service_quality: 3, communication: 2, parts_quality: 5, convenience: 5 } }

  it 'returns a Rating object associated with job, user and mechanic' do
    rating = service.rate(attrs)

    rating.should             be_a Rating
    rating.job_id.should      eq job.id
    rating.user_id.should     eq user.id
    rating.mechanic_id.should eq mechanic.id
  end

  it 'updates mechanics average rating' do
    service.rate(attrs)

    mechanic.rating.should eq 3.4
  end

  it 'returns false on failure' do
    invalid_attrs = attrs
    invalid_attrs.delete(:professional)

    service.rate(invalid_attrs).should be_false
  end
end
