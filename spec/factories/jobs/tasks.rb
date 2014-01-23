FactoryGirl.define do
  factory :task do
    note 'A note to mechanic'

    factory :service, class: 'Service' do
      type 'Service'
      service_plan
    end

    factory :inspection, class: 'Inspection' do
      title 'Break pedal vibration'
      description 'Mechanic should diagnose this problem'
    end

    factory :repair, class: 'Repair' do
      type 'Repair'
      title 'Replace break pads'

      trait :with_part do
        after :build do |r|
          r.task_items << build(:task_item, itemable: build(:part))
        end
      end

      trait :with_labour do
        after :build do |r|
          r.task_items << build(:task_item, itemable: build(:labour))
        end
      end

      trait :with_fixed_amount do
        after :build do |r|
          r.task_items << build(:task_item, itemable: build(:fixed_amount))
        end
      end
    end
  end
end
