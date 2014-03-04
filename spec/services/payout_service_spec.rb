require 'spec_helper'

describe PayoutService do
  let(:mechanic)      { create :mechanic }
  let(:job)           { create :job, :with_service, :assigned, mechanic: mechanic }
  let(:payout)        { create :payout, mechanic: mechanic, job: job }
  let(:payout_attrs)  { attributes_for :payout, amount: 50 }

  subject(:payout_service) { PayoutService.new(mechanic, job) }

  specify 'records a new payout' do
    payout_service.record_payout(payout_attrs)

    Payout.count.should eq 1
    mechanic.total_earnings.should eq 50
  end

  specify 'edits existing payout' do
    attrs = payout_attrs.merge(id: payout.id, amount: 100)
    payout_service.record_payout(attrs)

    Payout.count.should eq 1
    mechanic.total_earnings.should eq 100
  end

  specify 'does not record invalid payout' do
    attrs = payout_attrs
    attrs.delete(:amount)
    payout_service.record_payout(attrs)

    Payout.count.should eq 0
    mechanic.total_earnings.should eq 0
  end

  specify 'fails with non-existing payout ID' do
    attrs = payout_attrs.merge(id: 123)

    expect { payout_service.record_payout(attrs) }.to raise_error

    Payout.count.should eq 0
    mechanic.total_earnings.should eq 0
  end
end
