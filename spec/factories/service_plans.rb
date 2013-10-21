FactoryGirl.define do
  sequence(:kms) { |n| n * 1000 }

  factory :service_plan do
    title           ''
    kms_travelled   { generate(:kms) }
    months          6
    cost            350.0
    make
    model
    model_variation
    inclusions      'Service inclusions'
    instructions    'Mechanic instructions'
    parts           'Parts needed'
    notes           'Additional notes'

    factory :custom_service_plan do
      title           'Custom service'
      kms_travelled   nil
      months          nil
    end

    factory :default_service_plan do
      model_variation nil
    end
  end
end
