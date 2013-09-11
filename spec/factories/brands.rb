FactoryGirl.define do
  sequence(:brand_name) { |n| "Brand#{n}" }

  factory :brand do
    name { generate(:brand_name) }
  end
end
