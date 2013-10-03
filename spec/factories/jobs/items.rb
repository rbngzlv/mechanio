FactoryGirl.define do
  factory :part do
    name 'Break pad'
    quantity 4
    cost 54.0
  end

  factory :labour do
    description 'Replace break pads'
    duration 90
    hourly_rate 45.0
  end
end
