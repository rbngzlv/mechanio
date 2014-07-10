require 'spec_helper'

describe EventsManager do
  let(:mechanic)        { create :mechanic }
  let(:events_manager)  { EventsManager.new(mechanic) }
  let(:events_list)     { events_manager.events_list }
  let(:today)           { Date.today }
  let(:today_short)     { today.strftime('%-d %b') }
  let(:tomorrow)        { Time.tomorrow }
  let(:start_time)      { today.in_time_zone.change(hour: 9) }
  let(:end_time)        { start_time + 3.hours }
  let(:event_params) {{
    start_date: today.to_s,
    start_time: '9',
    end_time: '17'
  }}

  describe '#create_event' do
    specify 'non-recurring event' do
      event = events_manager.create_event(event_params)

      event.should be_a Event
      event.persisted?.should be_true

      events_list.count.should eq 1
      events_list.first[:title].should eq '9 AM - 5 PM'
    end

    specify 'daily event' do
      event = events_manager.create_event(event_params.merge({
        repeat: true,
        recurrence: 'daily'
      }))

      event.should be_a Event
      event.persisted?.should be_true

      events_list.count.should >= 365
      events_list.first[:title].should eq "daily from #{today_short}, 9 AM - 5 PM"
    end

    specify 'weekly event' do
      event = events_manager.create_event(event_params.merge({
        repeat: true,
        recurrence: 'weekly'
      }))

      event.should be_a Event
      event.persisted?.should be_true

      events_list.count.should >= 52
      events_list.first[:title].should eq "weekly from #{today_short}, 9 AM - 5 PM"
    end

    context 'monthly event' do
      specify 'timed event' do
        event = events_manager.create_event(event_params.merge({
          repeat: true,
          recurrence: 'monthly'
        }))

        event.should be_a Event
        event.persisted?.should be_true

        date = today.strftime('%-d %b')
        events_list.count.should >= 12
        events_list.first[:title].should eq "monthly from #{date}, 9 AM - 5 PM"
      end
    end
  end

  describe '#delete_event' do
    it 'deletes day off' do
      event = create :event, mechanic: mechanic
      expect {
        events_manager.delete_event(event.id)
      }.to change { Event.count }.by(-1)
    end

    it 'does not delete appointment' do
      event = create :event, job: create(:job, :with_service, mechanic: mechanic), mechanic: mechanic
      expect {
        events_manager.delete_event(event.id)
      }.to_not change { Event.count }
    end

    it 'deletes single occurrence' do
      event = create :event, recurrence: 'daily', count: 3, start_time: start_time, end_time: end_time, mechanic: mechanic
      date = (start_time + 1.day).to_date.to_s

      expect {
        events_manager.delete_occurence(event, date)
      }.to change { events_manager.events_list.count }.from(3).to(2)
    end
  end

  describe '#events_list' do
    let!(:event) { create :event, start_time: start_time, end_time: end_time, mechanic: mechanic }
    let!(:repeated_event) { create :event,
      recurrence: 'daily',
      start_time: start_time + 2.days,
      end_time: end_time + 2.days,
      count: 2,
      mechanic: mechanic
    }

    it 'builds a list with single and repeated events' do
      events_list.length.should eq 3
      check_event_hash(events_list[0], event)
      check_event_hash(events_list[1], repeated_event)
    end
  end

  describe '#available_at?' do
    before do
      create :event, mechanic: mechanic, start_time: start_time, end_time: end_time
      mechanic.events.reload
    end
    
    it 'is available' do
      time = start_time + 4.hours
      events_manager.available_at?(time).should be_true
    end

    it 'is unavailable' do
      time = start_time + 1.hour
      events_manager.available_at?(time).should be_false
    end
  end

  describe '#conflicts_with?' do
    before do
      create :event, mechanic: mechanic, start_time: start_time, end_time: end_time
      create :event, :with_job, mechanic: mechanic, start_time: start_time + 4.days, end_time: end_time + 4.days
      mechanic.events.reload
    end

    it 'conflicts' do
      event1 = build :event, mechanic: mechanic, start_time: start_time + 2.days, end_time: end_time, recurrence: 'daily', count: 4
      event2 = build :event, mechanic: mechanic, start_time: start_time, end_time: end_time
      event3 = build :event, mechanic: mechanic, start_time: start_time + 5.days, end_time: end_time + 5.days
      event1.build_schedule
      event2.build_schedule
      event3.build_schedule

      events_manager.conflicts_with?(event1).should be_true
      events_manager.conflicts_with?(event2).should be_true
      events_manager.conflicts_with?(event3).should be_false
    end
  end

  def check_event_hash(hash, event)
    hash.should == {
      start: event.start_time,
      end:   event.end_time,
      title: event.title,
      url:   "/mechanics/events.#{event.id}",
      id:    event.id,
      className: event.job ? 'work' : 'day-off'
    }
  end
end
