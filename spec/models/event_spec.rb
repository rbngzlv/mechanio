require 'spec_helper'

describe Event do
  subject { build :event }

  let(:mechanic) { create :mechanic }

  it { should belong_to :mechanic }
  it { should belong_to :job }

  it { should validate_presence_of :date_start }
  it { should validate_presence_of :time_start }
  it { should validate_presence_of :time_end }
  it { should validate_presence_of :mechanic }
  it { should ensure_inclusion_of(:recurrence).in_array(['daily', 'weekly', 'monthly']) }
  it { should allow_value(nil, (Date.tomorrow + 1.day)).for(:date_end) }
  it { should_not allow_value(Date.today).for(:date_end) }

  it 'does validate by uniqueness for single mechanic', pending: 'this validation is turned off for now' do
    event1 = create(:event, :weekly, mechanic: mechanic)
    event2 = build(:event, :weekly, mechanic: mechanic)

    errors = { date_start: ['there is another event on this date'] }
    event2.should_not be_valid
    event2.errors.messages.should eq errors
  end

  specify '.repeated' do
    single = create :event
    weekly = create :event, :weekly
    daily  = create :event, :daily

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
      event = build(:event, :whole_day, date_start: date, recurrence: :weekly)
      event.set_title
      event.title.should eq "weekly from 5 Nov, 9 AM - 7 PM"
    end

    specify do
      event = build(:event, date_start: date, time_start: date + 10.hours, time_end: date + 12.hours, recurrence: :weekly)
      event.set_title
      event.title.should eq "weekly from 5 Nov, 10 AM - 12 PM"
    end

    specify do
      event = build(:event, date_start: date)
      event.set_title
      event.title.should eq "9 AM - 11 AM"
    end

    specify do
      event = build(:event, date_start: date, time_start: date + 10.hours, time_end: date + 12.hours)
      event.set_title
      event.title.should eq "10 AM - 12 PM"
    end
  end
end
