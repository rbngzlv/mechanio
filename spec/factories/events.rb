FactoryGirl.define do
  factory :event do
    date_start    Date.tomorrow
    mechanic
    time_start { date_start.in_time_zone.change(hour: 9) }
    time_end   { date_start.in_time_zone.change(hour: 11) }

    trait :whole_day do
      time_end  { date_start.in_time_zone.change(hour: 19) }
    end

    trait :daily do
      recurrence  'daily'
    end

    trait :weekly do
      recurrence  'weekly'
    end

    trait :monthly do
      recurrence  'monthly'
    end

    trait :with_job do
      job { build_stubbed :job, :with_service }
    end
  end
end
