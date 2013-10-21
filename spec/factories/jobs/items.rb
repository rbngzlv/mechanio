FactoryGirl.define do
  factory :task_item do
  end

  factory :fixed_amount do
    description 'payment description'
    cost 100
  end

  factory :part do
    name 'Break pad'
    quantity 2
    unit_cost 54.0
  end

  factory :labour do
    description 'Replace break pads'
    duration_hours 2
    duration_minutes 30
  end
end
