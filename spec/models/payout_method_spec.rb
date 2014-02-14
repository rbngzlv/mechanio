require 'spec_helper'

describe PayoutMethod do
  it { should belong_to :mechanic }

  describe 'validations' do
    let(:payout_method) { build :payout_method }

    it { payout_method.should be_valid }

    describe 'presence' do
      it { should_not allow_value(nil).for(:account_name) }
      it { should_not allow_value(nil).for(:bsb_number) }
      it { should_not allow_value(nil).for(:mechanic) }
      it { should_not allow_value(nil).for(:account_number) }
    end

    describe 'digits only' do
      it { should_not allow_value('string').for(:account_number) }
      it do
        should_not allow_value('1_str' ).for(:account_number)
        subject.errors.messages[:account_number].should be_eql ['should be digits only']
      end
      it { should allow_value('123').for(:account_number) }

      it { should_not allow_value('string').for(:bsb_number) }
      it { should_not allow_value('1_str' ).for(:bsb_number) }
      it { should allow_value('123').for(:bsb_number) }
    end

    specify 'bsb_number should be max 6' do
      6.times do |i|
        payout_method.bsb_number = '1' * (i + 1)
        payout_method.should be_valid
      end
      payout_method.bsb_number = '1234567'
      payout_method.should_not be_valid
    end
  end
end
