require 'spec_helper'

describe Event do
  it 'does validate by uniqueness for single mechanic' do
    event = build(:event, mechanic: create(:mechanic), recurrence: :weekly)
    unique_event = event.dup
    unique_event.save
    event.should_not be_valid
    event.mechanic = build(:mechanic)
    event.should be_valid
  end

  specify '.repeated' do
    create :event, recurrence: nil
    desired_event = create :event, recurrence: :weekly
    create :event, recurrence: :daily
    (events = described_class.repeated(:weekly)).length.should be 1
    events.last.should == desired_event
  end

  specify '.time_slot' do
    t = Time.now
    desired_event = create :event, time_start: t, time_end: t + 2.hour
    create :event, time_start: t - 1.hour, time_end: t + 1.hour
    create :event
    (events = described_class.time_slot(t)).length.should be 1
    events.last.should == desired_event
  end

  context '.set_title' do
    let(:today)             { Date.today }
    let(:today_short)       { today.to_s(:short) }
    let(:time_start)        { today + 7.hour }
    let(:time_end)          { time_start + 2.hour }
    let(:time_range_string) { "#{time_start.to_s(:short)} - #{time_end.strftime('%H:%M')}" }

    specify do
      event = create(:event, recurrence: :weekly)
      event.title.should be_eql "weekly from #{today_short} for all day event"
    end

    specify do
      event = create(:event, recurrence: :weekly, time_start: time_start, time_end: time_end)
      event.title.should be_eql "weekly from #{time_range_string}"
    end

    specify do
      event = create(:event)
      event.title.should be_eql "whole day"
    end

    specify do
      event = create(:event, time_start: time_start, time_end: time_end)
      event.title.should be_eql "#{time_range_string}"
    end
  end
end
