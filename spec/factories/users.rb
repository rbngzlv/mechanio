FactoryGirl.define do
  factory :user do
    first_name  'John'
    last_name   'Doe'
    email       'email@host.com'
    password    'password'
    confirmed_at Date.today
  end
end
