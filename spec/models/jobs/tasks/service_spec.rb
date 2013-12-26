require 'spec_helper'

describe Service do

  let(:service)         { create :service, service_plan: service_plan }
  let(:service_plan)    { create :service_plan, cost: 100, kms_travelled: 1000 }
  let(:service_plan_2)  { create :service_plan, cost: 200, kms_travelled: 3000 }
  let(:task_item)       { service.task_items.first }

  it { should belong_to :service_plan }

  it { should validate_presence_of :service_plan }

  it 'creates ServiceCost task item' do
    service.reload.task_items.count.should eq 1
    service.title.should eq "#{service_plan.display_title} service"
    task_item.cost.should eq service_plan.cost
    task_item.itemable.should be_a ServiceCost
    task_item.itemable.service_plan.should eq service_plan
  end

  it 'replaces ServiceCost task item when service plan changes' do
    service.service_plan_id = service_plan_2.id
    service.save

    service.reload.task_items.count.should eq 1
    service.title.should eq "#{service_plan_2.display_title} service"
    task_item.itemable.should be_a ServiceCost
    task_item.cost.should eq service_plan_2.cost
    task_item.itemable.service_plan.should eq service_plan_2
  end

  it 'sums items costs' do
    service.should be_valid
    service.set_cost
    service.cost.should eq task_item.cost
  end
end
