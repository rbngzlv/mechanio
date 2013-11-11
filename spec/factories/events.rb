FactoryGirl.define do
  factory :event do
    date_start    Date.current
    mechanic

    trait :day_off do
      date_start  Date.current - 8.week
      title       'Day off'
      recurrence  :weekly
    end
  end
end
