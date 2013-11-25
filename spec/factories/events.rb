FactoryGirl.define do
  factory :event do
    date_start    Date.current
    mechanic

    trait :weekly do
      recurrence  :weekly
    end

    trait :monthly do
      recurrence  :monthly
    end
  end
end
