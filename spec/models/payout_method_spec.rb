require 'spec_helper'

describe PayoutMethod do
  subject { build_stubbed :payout_method }

  it { should belong_to :mechanic }

  it { should validate_presence_of :account_name }
  it { should validate_presence_of :bsb_number }
  it { should validate_presence_of :account_number }
  it { should allow_value('1234', '1234567889').for(:account_number) }
  it { should_not allow_value(nil, '', 'asbs').for(:account_number) }
  it { should validate_presence_of :bsb_number }
  it { should allow_value('123456').for(:bsb_number) }
  it { should_not allow_value(nil, '', 'asbs', '12345', '1234567').for(:bsb_number) }
end
