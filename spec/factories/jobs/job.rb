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

    trait :with_payout do
      after :build do |j|
        j.payout = build(:payout)
      end
    end

    trait :with_appointment do
      scheduled_at { DateTime.tomorrow }
      assigned_at  { DateTime.now }

      after :build do |j|
        j.appointment = build(:appointment, user: j.user, mechanic: j.mechanic, scheduled_at: j.scheduled_at)

        j.event = build(:event,
          mechanic:   j.mechanic,
          start_time: j.scheduled_at,
          end_time:   j.scheduled_at + 2.hour
        )
      end
    end

    trait :pending do
      status 'pending'
      after :build do |j|
        j.tasks << build(:repair)
      end
    end

    trait :estimated do
      status  'estimated'
      cost    123
    end

    trait :assigned do
      mechanic
      with_credit_card
      with_appointment
      status 'assigned'
    end

    trait :completed do
      assigned
      status 'completed'
      completed_at { DateTime.yesterday }
    end

    trait :charged do
      completed
      transaction_id     '1234'
      transaction_status 'success'
      status             'charged'
    end

    trait :charge_failed do
      completed
      transaction_id     '1234'
      transaction_status 'error'
      status             'charge_failed'
    end

    trait :paid_out do
      charged
      with_payout
      status             'paid_out'
    end

    trait :rated do
      completed

      after :build do |j|
        j.rating = build :rating, job: j, user: j.user, mechanic: j.mechanic
      end
    end
  end
end
