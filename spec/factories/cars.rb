FactoryGirl.define do
  factory :car do
    user
    model_variation
    year      2012
    last_service_kms 10000
  end
end
