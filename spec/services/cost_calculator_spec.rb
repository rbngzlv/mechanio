require 'spec_helper'

describe CostCalculator do
  let(:cost_calculator)     { CostCalculator.new(job) }

  let(:job)                 { build :job, tasks: [service, repair, inspection], skip_set_cost: true }

  let(:service)             { build :service, task_items: [service_item] }
  let(:service_item)        { build :service_item }

  let(:repair)              { build :repair, task_items: [part_item, labour_item, fixed_item] }
  let(:part_item)           { build :part_item }
  let(:labour_item)         { build :labour_item }
  let(:fixed_item)          { build :fixed_amount_item }

  let(:inspection)          { build :inspection }
  let(:another_inspection)  { build :inspection }

  before do
    cost_calculator.set_job_cost
  end

  context 'a service ordered' do
    specify 'inspection is free' do
      verify_service_cost
      verify_repair_cost

      inspection.cost.should  eq 0

      job.cost.should         eq 683
      job.final_cost.should   eq 683
    end
  end

  context 'no service ordered' do
    let(:job) { build :job, tasks: [repair, inspection] }

    specify 'inspection is paid' do
      verify_repair_cost

      inspection.cost.should  eq 80

      job.cost.should         eq 413
      job.final_cost.should   eq 413
    end
  end

  context 'no service, multiple inspections' do
    let(:job) { build :job, tasks: [repair, inspection, another_inspection] }

    specify 'multiple inspections should cost as single inspection' do
      verify_repair_cost

      inspection.cost.should          eq 80
      another_inspection.cost.should  eq 0

      job.cost.should                 eq 413
      job.final_cost.should           eq 413
    end
  end

  context 'job with discount' do
    let(:job) { build :job, :with_discount, tasks: [repair] }

    specify 'final_cost should include discount' do
      verify_repair_cost

      job.cost.should                  eq 333
      job.discount_amount.to_f.should  eq 66.6
      job.final_cost.should            eq 266.4
    end
  end


  def verify_service_cost
    service.cost.should       eq 350
    service_item.cost.should  eq 350
  end

  def verify_repair_cost
    repair.cost.should        eq 333
    part_item.cost.should     eq 108
    labour_item.cost.should   eq 125
    fixed_item.cost.should    eq 100
  end
end
