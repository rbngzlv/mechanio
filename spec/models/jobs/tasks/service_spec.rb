require 'spec_helper'

describe Service do

  let(:service)       { create :service, service_plan: service_plan }
  let(:service_plan)  { create :service_plan }
  let(:task_item)     { service.task_items.first }

  it { should belong_to :service_plan }

  it { should validate_presence_of :service_plan }

  it 'copies title from service plan on create' do
    service.title.should eq "Service: #{service_plan.display_title}"
  end

  it 'creates fixed_amount task item' do
    service.reload.task_items.count.should eq 1
    task_item.cost.should eq service_plan.cost
  end

  it 'sums items costs' do
    service.cost.should eq task_item.cost
  end
end
