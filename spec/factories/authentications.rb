FactoryGirl.define do
  factory :authentication do
    provider 'facebook'
    uid      '1'
    user

    trait :gmail do
      provider 'google_oauth2'
    end

    trait :facebook do
      provider 'facebook'
    end
  end
end
