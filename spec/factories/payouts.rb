FactoryGirl.define do
  factory :payout do
    account_name    'Bank of Australia'
    account_number  '12345678900'
    bsb_number      '123456'
    transaction_id  'ASXS12312'
    amount          100
  end
end
