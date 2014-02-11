require 'spec_helper'

describe Labour do

  let(:labour) { build :labour, duration_hours: 2, duration_minutes: 30, hourly_rate: 50 }

  it { should have_one :task_item }

  it { should validate_presence_of :duration_hours }
  it { should ensure_inclusion_of(:duration_hours).in_array(Labour::HOURS) }
  it { should ensure_inclusion_of(:duration_minutes).in_array(Labour::MINUTES) }

  it 'saves hours and minutes' do
    labour = Labour.create(duration_hours: '1', duration_minutes: '30')
    labour.reload.tap do |l|
      l.duration_hours.should eq 1
      l.duration_minutes.should eq 30
    end
  end

  it 'calculates duration' do
    labour.duration.should eq 150
  end

  describe 'formats duration' do
    it { labour.display_duration.should eq '2 h 30 m' }
    it 'should slice minutes if their are excepted' do
      labour.duration_minutes = 0
      labour.display_duration.should eq '2 h'
    end
  end

  it 'calculates cost' do
    labour.should be_valid
    labour.set_cost
    labour.cost.should eq 125
  end
end
