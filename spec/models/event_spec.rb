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
    single = create :event
    weekly = create :event, recurrence: :weekly
    daily  = create :event, recurrence: :daily

    Event.repeated(:weekly).should eq [weekly]
    Event.repeated(:daily).should eq [daily]
  end

  specify '.time_slot' do
    time_slot = Date.tomorrow + 10.hours
    first  = create :event, time_start: time_slot, time_end: time_slot + 2.hour
    second = create :event, time_start: time_slot + 2.hours, time_end: time_slot + 4.hour

    Event.time_slot(time_slot).should eq [first]
  end

  specify '.is_appointment?' do
    event1 = build :event, :with_job
    event2 = build :event

    event1.is_appointment?.should eq true
    event2.is_appointment?.should eq false
  end

  context '.set_title' do
    let(:date) { Date.new(2010, 11, 5) }

    specify do
      event = build_stubbed(:event, :whole_day, date_start: date, recurrence: :weekly)
      event.set_title
      event.title.should eq "weekly from 5 Nov, all day"
    end

    specify do
      event = build_stubbed(:event, date_start: date, time_start: date + 10.hours, time_end: date + 12.hours, recurrence: :weekly)
      event.set_title
      event.title.should eq "weekly from 5 Nov, 10:00 - 12:00"
    end

    specify do
      event = build_stubbed(:event, date_start: date, time_start: nil, time_end: nil)
      event.set_title
      event.title.should eq "all day"
    end

    specify do
      event = build_stubbed(:event, date_start: date, time_start: date + 10.hours, time_end: date + 12.hours)
      event.set_title
      event.title.should eq "10:00 - 12:00"
    end
  end
end
