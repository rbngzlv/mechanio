FactoryGirl.define do
  factory :event do
    date_start    Date.tomorrow
    time_start    Date.tomorrow + 8.hours
    time_end      Date.tomorrow + 10.hours
    mechanic

    trait :whole_day do
      time_start nil
      time_end   nil
    end

    trait :weekly do
      recurrence  :weekly
    end

    trait :monthly do
      recurrence  :monthly
    end

    trait :with_job do
      job { build_stubbed :job_with_service }
    end
  end
end
