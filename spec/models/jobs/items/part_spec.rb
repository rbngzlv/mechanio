require 'spec_helper'

describe Part do

  it { should have_one :task_item }

  it { should validate_presence_of :name }
  it { should validate_presence_of :unit_cost }
  it { should validate_presence_of :quantity }

  it 'calculates cost on save' do
    part = create :part, unit_cost: 100, quantity: 3
    part.cost.should eq 300
  end
end
