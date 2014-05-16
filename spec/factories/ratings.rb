FactoryGirl.define do
  factory :rating do
    professional      2
    service_quality   3
    communication     2
    cleanness         5
    convenience       5
    published         true

    trait :with_user do
      after :build do |r|
        r.user = build :user
      end
    end

    trait :with_mechanic do
      after :build do |r|
        r.mechanic = build :mechanic
      end
    end

    trait :with_job do
      after :build do |r|
        r.job = build :job, :completed, :with_service
      end
    end
  end
end
