FactoryGirl.define do
  factory :appointment do
    user
    mechanic
    association :job, factory: :job_with_service
    scheduled_at { Date.tomorrow }
  end
end
