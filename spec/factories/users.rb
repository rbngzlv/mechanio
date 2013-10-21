FactoryGirl.define do
  sequence(:email) { |n| "email#{n}@host.com" }

  factory :user do
    first_name  'John'
    last_name   'User'
    email       { generate(:email) }
    password    'password'
    confirmed_at Date.today
  end
end
