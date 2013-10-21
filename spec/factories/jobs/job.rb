FactoryGirl.define do
  factory :job do
    user
    car
    location
    contact_email 'email@host.com'
    contact_phone '0410 123 456'

    trait :with_service do
      after :build do |j|
        service_plan = create(:service_plan, model_variation: j.car.model_variation)
        j.tasks << build(:service, service_plan: service_plan)
      end
    end

    trait :with_repair do
      after :build do |j|
        j.tasks << build(:repair, :with_part, :with_labour)
      end
    end

    trait :estimated do
      status  :estimated
      cost    123
    end

    trait :pending do
      status :pending
      after :build do |j|
        j.tasks << build(:repair)
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
