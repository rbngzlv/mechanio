require 'spec_helper'

describe JobDiscountService do

  let(:service)       { JobDiscountService.new(job, discount_code) }
  let(:user)          { create :user }
  let(:job)           { create :job, :with_service, :estimated, user: user }
  let(:discount)      { create :discount, uses_left: 1 }
  let(:discount_code) { discount.code }

  describe 'estimated job' do
    it 'associates discount with job' do
      expect { service.apply_discount }.to change { job.discount }.from(nil).to(discount)
    end

    it 'applies discount to job cost' do
      job.cost.should eq 350
      expect { service.apply_discount }.to change { job.final_cost }.from(350).to(280)
    end

    it 'decreases discount uses count' do
      expect { service.apply_discount }.to change { discount.reload.uses_left }.from(1).to(0)
    end

    it 'returns true on success' do
      service.apply_discount.should be_true
    end
  end

  describe 'temporary job' do
    let(:job) { create_temporary_job }

    it 'associates discount with job' do
      expect { service.apply_discount }.to change { job.reload.discount }.from(nil).to(discount)
    end

    it 'does not calculates cost' do
      job.should_not_receive(:set_cost)
      service.apply_discount
    end
  end

  describe 'validations' do
    let(:errors) { service.errors.messages[:base] }

    context 'unexisting discount code' do
      let(:discount_code) { 'Unexisting' }

      it 'fails' do
        service.apply_discount.should be_false
        job.discount.should be_nil
        errors.should include 'Discount code is invalid'
      end
    end

    context 'no uses left' do
      let(:discount) { create :discount, uses_left: 0 }

      it 'fails' do
        service.apply_discount.should be_false
        job.discount.should be_nil
        errors.should include 'This discount code was already used'
      end
    end

    context 'user already used this discount with another job' do
      before do
        create :job, :with_service, user: user, discount: discount
      end

      it 'fails' do
        service.apply_discount.should be_false
        job.discount.should be_nil
        errors.should include 'This discount code was already used'
      end
    end

    context 'start date is in future' do
      let(:discount) { create :discount, starts_at: Date.tomorrow }

      it 'fails' do
        service.apply_discount.should be_false
        job.discount.should be_nil
        errors.should include 'This discount code is not active'
      end
    end

    context 'end date is in the past' do
      let(:discount) { create :discount, ends_at: Date.yesterday }

      it 'fails' do
        service.apply_discount.should be_false
        job.discount.should be_nil
        errors.should include 'This discount code is not active'
      end
    end
  end
end
