FactoryGirl.define do
  factory :appointment do
    scheduled_at { Date.tomorrow }
  end
end
