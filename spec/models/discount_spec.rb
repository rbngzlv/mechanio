require 'spec_helper'

describe Discount do

  let(:percent_discount) { build_stubbed :discount, discount_type: 'percent', discount_value: 20 }
  let(:amount_discount)  { build_stubbed :discount, discount_type: 'amount', discount_value: 20 }

  it { should validate_presence_of :title }
  it { should validate_presence_of :code }
  it { should validate_presence_of :discount_type }
  it { should validate_presence_of :discount_value }
  it { should ensure_inclusion_of(:discount_type).in_array(Discount::DISCOUNT_TYPES) }
  it { should validate_numericality_of :discount_value }
  it { should validate_numericality_of :uses_left }
  it { should allow_value(nil).for(:uses_left) }

  specify '#apply_discount' do
    percent_discount.apply_discount(200).should eq 160
    amount_discount.apply_discount(200).should eq 180
  end

  specify '#discount_amount' do
    percent_discount.discount_amount(200).should eq 40
    amount_discount.discount_amount(200).should eq 20
  end

  specify '#display_value' do
    percent_discount.display_value.should eq '20%'
    amount_discount.display_value.should eq '$20.00'
  end
end
