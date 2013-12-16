FactoryGirl.define do
  factory :user do
    first_name  'John'
    last_name   'User'
    email       { generate(:email) }
    password    'password'
    confirmed_at Date.today
    mobile_number '0412345678'
  end
end
