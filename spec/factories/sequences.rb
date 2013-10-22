FactoryGirl.define do
  sequence(:email) { |n| "email#{n}@host.com" }
end
