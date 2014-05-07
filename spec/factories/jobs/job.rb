FactoryGirl.define do
  factory :job do
    user
    car
    location
    contact_email 'email@host.com'
    contact_phone '0410123456'

    ignore do
      skip_set_cost false
    end

    before(:create) do |j, evaluator|
      j.set_cost unless evaluator.skip_set_cost
    end

    trait :with_service do
      after :build do |j|
        service_plan = create(:service_plan, model_variation: j.car.model_variation)
        j.tasks << build(:service, service_plan: service_plan)
      end
    end

    trait :with_repair do
      after :build do |j|
        j.tasks << build(:repair, :with_part, :with_labour, :with_fixed_amount)
      end
    end

    trait :with_inspection do
      after :build do |j|
        j.tasks << build(:inspection)
      end
    end

    trait :with_credit_card do
      after :build do |j|
        j.credit_card = build(:credit_card)
      end
    end

    trait :with_discount do
      after :build do |j|
        j.discount = build(:discount)
      end
    end

    trait :estimated do
      status  'estimated'
      cost    123
    end

    trait :pending do
      status 'pending'
      after :build do |j|
        j.tasks << build(:repair)
      end
    end

    trait :assigned do
      mechanic
      credit_card
      status 'assigned'
      scheduled_at { DateTime.tomorrow }
      assigned_at  { DateTime.now }

      after :build do |j|
        j.appointment = build(:appointment, user: j.user, mechanic: j.mechanic)
      end
    end

    trait :with_event do
      after :create do |j|
        create(:event, job: j, mechanic: j.mechanic)
      end
    end

    trait :completed do
      mechanic
      status 'completed'
      completed_at { DateTime.now }
      scheduled_at { DateTime.tomorrow }
    end

    trait :rated do
      rating
    end
  end
end
