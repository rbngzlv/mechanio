require 'spec_helper'

describe Labour do

  it { should have_one :task_item }

  it { should validate_presence_of :description }
  it { should validate_presence_of :duration }
  it { should validate_presence_of :hourly_rate }

  it 'calculates cost', pending: 'need to figure a way to handle duration display and storage' do
  end
end
