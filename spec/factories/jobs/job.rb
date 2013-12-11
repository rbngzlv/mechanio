FactoryGirl.define do
  factory :job do
    user
    car
    location
    contact_email 'email@host.com'
    contact_phone '0410123456'

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

    trait :assigned do
      mechanic
      status :assigned
      scheduled_at { DateTime.tomorrow }
    end

    trait :confirmed do
      credit_card
      status :confirmed
    end

    trait :completed do
      mechanic
      status :completed
      scheduled_at { DateTime.now }
    end

    factory :job_with_service, traits: [:with_service]
    factory :assigned_job, traits: [:with_service, :assigned]
  end
end
