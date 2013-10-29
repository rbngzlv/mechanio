FactoryGirl.define do
  factory :location do
    state
    address 'Palm beach 55'
    suburb 'Abbotsbury'
    postcode '0200'

    trait :with_type do
      location_type 'location'
    end

    trait :with_coordinates do
      latitude    38.500000
      longitude   -75.500000
    end
  end
end
