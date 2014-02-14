FactoryGirl.define do
  sequence(:number) { |n| "0000#{n}" }

  factory :payout_method do
    account_name    'Account Name'
    bsb_number      { generate(:number) }
    account_number  { generate(:number) }
    mechanic
  end
end
