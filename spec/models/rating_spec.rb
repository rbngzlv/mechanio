require 'spec_helper'

describe Rating do

  let(:rating) { build_stubbed :rating, professional: 2, service_quality: 3, communication: 2, cleanness: 5, convenience: 5 }

  it { should belong_to :user }
  it { should belong_to :mechanic }
  it { should belong_to :job }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:mechanic) }
  it { should validate_presence_of(:job) }

  it { should validate_presence_of(:professional) }
  it { should validate_presence_of(:service_quality) }
  it { should validate_presence_of(:communication) }
  it { should validate_presence_of(:cleanness) }
  it { should validate_presence_of(:convenience) }

  it { should ensure_inclusion_of(:professional).in_range(1..5) }
  it { should ensure_inclusion_of(:service_quality).in_range(1..5) }
  it { should ensure_inclusion_of(:communication).in_range(1..5) }
  it { should ensure_inclusion_of(:cleanness).in_range(1..5) }
  it { should ensure_inclusion_of(:convenience).in_range(1..5) }

  specify '#published' do
    published_rating   = create :rating, :with_job, :with_user, :with_mechanic, published: true
    unpublished_rating = create :rating, :with_job, :with_user, :with_mechanic, published: false

    Rating.published.should eq [published_rating]
  end

  specify '#average' do
    rating.average.should eq 3.4
  end
end
