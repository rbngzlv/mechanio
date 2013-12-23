require 'spec_helper'

describe Event do
  it { should belong_to :mechanic }
  it { should belong_to :job }

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

  specify '.is_appointment?' do
    event1 = build :event, :with_job
    event2 = build :event

    event1.is_appointment?.should eq true
    event2.is_appointment?.should eq false
  end

  context '.set_title' do
    let(:date)              { Date.new(2012, 11, 5) }
    let(:date_short)        { date.to_s(:short) }
    let(:time_start)        { date + 7.hour }
    let(:time_end)          { time_start + 2.hour }
    let(:time_range_string) { "#{time_start.to_s(:short)} - #{time_end.strftime('%H:%M')}" }

    specify do
      event = build_stubbed(:event, date_start: date, recurrence: :weekly)
      event.set_title
      event.title.should eq "weekly from 5 Nov, all day"
    end

    specify do
      event = build_stubbed(:event, date_start: date, recurrence: :weekly, time_start: time_start, time_end: time_end)
      event.set_title
      event.title.should eq "weekly from 5 Nov, 07:00 - 09:00"
    end

    specify do
      event = build_stubbed(:event, date_start: date)
      event.set_title
      event.title.should eq "all day"
    end

    specify do
      event = build_stubbed(:event, date_start: date, time_start: time_start, time_end: time_end)
      event.set_title
      event.title.should eq "07:00 - 09:00"
    end
  end
end
