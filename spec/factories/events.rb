FactoryGirl.define do
  factory :event do
    start_time Date.tomorrow.in_time_zone.change(hour: 9, minute: 0)
    end_time   Date.tomorrow.in_time_zone.change(hour: 11, minute: 0)
    mechanic

    after :build do |e|
      e.build_schedule
    end

    trait :with_job do
      job { build_stubbed :job, :with_service }
    end
  end
end
