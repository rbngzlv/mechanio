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

    factory :job_with_service, traits: [:with_service]
  end
end
