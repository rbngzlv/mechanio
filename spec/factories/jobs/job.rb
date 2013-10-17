FactoryGirl.define do
  factory :job do
    user
    car
    location
    contact_email 'email@host.com'
    contact_phone '0410 123 456'

    trait :with_service do
      after :build do |j|
        j.tasks << build(:service)
      end
    end

    trait :with_repair do
      after :build do |j|
        j.tasks << build(:repair, :with_part, :with_labour)
      end
    end

    factory :job_with_service, traits: [:with_service]

    trait :with_mechanic do
      mechanic
      status 'assigned'
      scheduled_at { DateTime.now }
    end

    factory :assigned_job, traits: [:with_service, :with_mechanic]
  end
end
