FactoryGirl.define do
  factory :location do
    state
    address 'Palm beach 55'
    postcode '0200'

    after(:build) do |location|
      location.suburb = build :sydney_suburb
    end

    trait :with_type do
      location_type 'location'
    end

    trait :with_coordinates do
      latitude    38.500000
      longitude   -75.500000
    end
  end
end
