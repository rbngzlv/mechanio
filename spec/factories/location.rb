FactoryGirl.define do
  factory :location do
    state
    address 'Palm beach 55'
    suburb 'Abbotsbury'
    postcode '0200'

    trait :with_type do
      location_type 'location'
    end
  end
end
