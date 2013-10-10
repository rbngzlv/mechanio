require 'spec_helper'

describe TaskItem do

  it { should belong_to :task }
  it { should belong_to :itemable }

  it 'delegates cost to itemable' do
    subject.stub(:itemable).and_return double(cost: 123)
    subject.cost.should eq 123
  end
end
