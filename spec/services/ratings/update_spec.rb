require 'spec_helper'

describe Ratings::Update do
  let(:service)   { Ratings::Update.new(rating) }
  let(:mechanic)  { create :mechanic }
  let(:rating)    { create :rating, :with_user, :with_job, mechanic: mechanic }
  let(:attrs)     { { id: rating.id, professional: 5, service_quality: 1, communication: 1, cleanness: 1, convenience: 4 } }

  before do
    rating
    mechanic.update_rating
    mechanic.rating.should eq 3.4
  end

  it 'updates rating' do
    service.call(attrs).should be_true
    mechanic.reload.rating.should eq 2.4
  end

  it 'excludes unpublished rating' do
    params = attrs
    params[:published] = false

    service.call(attrs).should be_true
    mechanic.reload.rating.should eq 0
  end
end
