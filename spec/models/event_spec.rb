require 'spec_helper'

describe Event do
  subject { build :event, start_time: start_time, end_time: end_time }

  let(:mechanic)   { create :mechanic }
  let(:start_time) { Date.new(2014, 12, 1).in_time_zone.change(hour: 9, minute: 0) }
  let(:end_time)   { start_time + 3.hours }

  it { should belong_to :mechanic }
  it { should belong_to :job }

  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }
  it { should validate_presence_of :mechanic }
  it { should ensure_inclusion_of(:recurrence).in_array(['daily', 'weekly', 'monthly']) }

  describe '.verify_end_time' do
    it { should allow_value(start_time + 2.hours).for(:end_time) }
    it { should_not allow_value(start_time - 2.hours).for(:end_time) }
    it { should_not allow_value(start_time).for(:end_time) }
  end

  specify '.is_appointment?' do
    event1 = build :event, :with_job
    event2 = build :event

    event1.is_appointment?.should eq true
    event2.is_appointment?.should eq false
  end

  context '.set_title' do
    specify do
      event = build(:event, start_time: start_time, end_time: end_time, recurrence: 'monthly')
      event.set_title
      event.title.should eq 'monthly from 1 Dec, 9 AM - 12 PM'
    end

    specify do
      event = build(:event, start_time: start_time, end_time: end_time, recurrence: 'weekly')
      event.set_title
      event.title.should eq 'weekly from 1 Dec, 9 AM - 12 PM'
    end

    specify do
      event = build(:event, start_time: start_time, end_time: end_time)
      event.set_title
      event.title.should eq '9 AM - 12 PM'
    end
  end

  specify 'build schedule on create' do
    attrs = attributes_for(:event, recurrence: 'weekly', start_time: start_time, end_time: end_time, count: 5).merge(mechanic: mechanic)
    event = Event.create(attrs)

    event.reload.schedule.should be_a IceCube::Schedule
    event.reload.schedule.to_hash.should eq schedule_hash
  end

  specify '.build_schedule' do
    event = Event.new(recurrence: 'weekly', start_time: start_time, end_time: end_time, count: 5)

    event.build_schedule.to_hash.should eq schedule_hash
  end

  specify 'exclude single occurrence' do
    event = create :event, recurrence: 'daily', count: 3, start_time: start_time, end_time: end_time
    event.schedule.occurrences(start_time + 4.days).count.should eq 3

    event.add_exception_time(start_time + 1.day)
    event.save

    event.reload.schedule.occurrences(start_time + 4.days).count.should eq 2
  end

  def schedule_hash
    {
      start_date: { time: Time.parse('2014-12-01 09:00:00 UTC'), zone: 'UTC' },
      end_time:   { time: Time.parse('2014-12-01 12:00:00 UTC'), zone: 'UTC' },
      rrules: [
        { validations: {}, rule_type: 'IceCube::WeeklyRule', interval: 1, week_start: 0, count: 5 }
      ],
      exrules: [],
      rtimes: [],
      extimes: []
    }
  end
end
