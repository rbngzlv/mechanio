require 'spec_helper'

describe Payout do

  it { should belong_to :mechanic }
  it { should belong_to :job }

  it { should validate_presence_of :account_name }
  it { should validate_presence_of :account_number }
  it { should validate_presence_of :bsb_number }
  it { should validate_presence_of :amount }
  it { should validate_presence_of :transaction_id }
end
