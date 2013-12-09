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

    trait :job do
      date_start  Date.tomorrow
      time_start  Time.new(2000, 01, 01, 9, 0, 0, '+00:00')
      time_end    Time.new(2000, 01, 01, 11, 0, 0, '+00:00')
      job         { create :job_with_service }
    end
  end
end
