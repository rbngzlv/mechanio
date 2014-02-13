FactoryGirl.define do
  factory :task_item do

    factory :service_item do
      association :itemable, factory: :service_cost
    end

    factory :part_item do
      association :itemable, factory: :part
    end

    factory :labour_item do
      association :itemable, factory: :labour
    end

    factory :fixed_amount_item do
      association :itemable, factory: :fixed_amount
    end
  end

  factory :service_cost do
    service_plan
  end

  factory :fixed_amount do
    description 'Fixed amount'
    cost 100
  end

  factory :part do
    name 'Break pad'
    quantity 2
    unit_cost 54.0
  end

  factory :labour do
    duration_hours 2
    duration_minutes 30
  end
end
