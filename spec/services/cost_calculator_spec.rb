require 'spec_helper'

describe CostCalculator do
  let(:job)          { build_stubbed :job, tasks: [service, repair, inspection] }

  let(:service)      { build_stubbed :service, task_items: [service_item] }
  let(:repair)       { build_stubbed(:repair, task_items: [part_item, labour_item, fixed_item]) }
  let(:inspection)   { build_stubbed(:inspection) }
  let(:another_inspection)   { build_stubbed(:inspection) }

  let(:service_item) { build_stubbed(:service_item) }
  let(:part_item)    { build_stubbed(:part_item) }
  let(:labour_item)  { build_stubbed(:labour_item) }
  let(:fixed_item)   { build_stubbed(:fixed_amount_item) }

  subject { CostCalculator.new(job) }

  describe '#set_job_cost' do

    before do
      subject.set_job_cost

      service_item.cost.should  eq 350
      part_item.cost.should     eq 108
      labour_item.cost.should   eq 125
      fixed_item.cost.should    eq 100

      repair.cost.should        eq 333
    end

    context 'a service ordered' do
      specify 'inspection is free' do
        service.cost.should     eq 350
        inspection.cost.should  eq 0
        job.cost.should         eq 683
        job.final_cost.should   eq 683
      end
    end

    context 'no service ordered' do
      let(:job) { build_stubbed :job, tasks: [repair, inspection] }

      specify 'inspection is paid' do
        inspection.cost.should  eq 80
        job.cost.should         eq 413
        job.final_cost.should   eq 413
      end
    end

    context 'no service, multiple inspections' do
      let(:job) { build_stubbed :job, tasks: [repair, inspection, another_inspection] }

      specify 'multiple inspections should cost as single inspection' do
        inspection.cost.should          eq 80
        another_inspection.cost.should  eq 0
        job.cost.should                 eq 413
        job.final_cost.should           eq 413
      end
    end

    context 'job with discount' do
      let(:job) { build :job, :with_discount, tasks: [repair] }

      specify 'final_cost should include discount' do
        job.cost.should                  eq 333
        job.discount_amount.to_f.should  eq 66.6
        job.final_cost.should            eq 266.4
      end
    end
  end
end
