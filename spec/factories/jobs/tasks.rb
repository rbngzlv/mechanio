FactoryGirl.define do
  factory :task do
    note 'A note to mechanic'

    factory :service, class: 'Service' do
      type 'Service'
      service_plan
    end

    factory :repair, class: 'Repair' do
      type 'Repair'
      title 'Replace break pads'
    end

    trait :with_part do
      after :build do |r|
        r.task_items << build(:part_item)
      end
    end

    trait :with_labour do
      after :build do |r|
        r.task_items << build(:labour_item)
      end
    end

    trait :with_fixed_amount do
      after :build do |r|
        r.task_items << build(:fixed_amount_item)
      end
    end
  end

  factory :inspection, class: 'Inspection' do
    note 'A note to mechanic'
    title 'Break pedal vibration'
    description 'Mechanic should diagnose this problem'
  end
end
