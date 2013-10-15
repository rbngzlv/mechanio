require 'spec_helper'

describe Labour do

  let(:labour) { build :labour, duration_hours: 2, duration_minutes: 30 }

  it { should have_one :task_item }

  it { should validate_presence_of :description }
  it { should validate_presence_of :duration_hours }
  it { should validate_presence_of :duration_minutes }
  it { should validate_presence_of :hourly_rate }
  it { should ensure_inclusion_of(:duration_hours).in_array(Labour::HOURS) }
  it { should ensure_inclusion_of(:duration_minutes).in_array(Labour::MINUTES) }

  it 'calculates duration' do
    labour.duration.should eq 150
  end

  it 'formats duration' do
    labour.display_duration.should eq '2:30'
  end

  it 'calculates cost after validation' do
    labour.should be_valid
    labour.cost.should eq 125
  end
end
