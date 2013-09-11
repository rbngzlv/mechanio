FactoryGirl.define do
  sequence(:make_name) { |n| "Make#{n}" }

  factory :make do
    name { generate(:make_name) }
  end
end
