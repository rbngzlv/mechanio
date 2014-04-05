FactoryGirl.define do
  factory :discount do
    title           '20% off'
    code            '20OFF'
    discount_type   'percent'
    discount_value  20
    uses_left       nil
    starts_at       nil
    ends_at         nil
  end
end
