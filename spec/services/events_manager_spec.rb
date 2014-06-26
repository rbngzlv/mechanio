require 'spec_helper'

describe EventsManager do
  let(:mechanic)        { create :mechanic }
  let(:events_manager)  { EventsManager.new(mechanic) }
  let(:events_list)     { events_manager.events_list }
  let(:today)           { Time.now }
  let(:event_params) {{
    date_start: today.to_s,
    time_start: '9',
    time_end: '17'
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

      date = today.strftime('%-d %b')
      events_list.count.should >= 365
      events_list.first[:title].should eq "daily from #{date}, 9 AM - 5 PM"
    end

    specify 'weekly event' do
      event = events_manager.create_event(event_params.merge({
        repeat: true,
        recurrence: 'weekly'
      }))

      event.should be_a Event
      event.persisted?.should be_true

      date = today.strftime('%-d %b')
      events_list.count.should >= 52
      events_list.first[:title].should eq "weekly from #{date}, 9 AM - 5 PM"
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

    context 'overlapping event', pending: 'this validation is turned off for now' do
      before do
        create :event, :whole_day, date_start: today, mechanic: mechanic
      end

      specify 'does not create overlapping event' do
        event = events_manager.create_event({
          date_start: today.to_s,
          time_start: '9',
          time_end: '17'
        })

        event.should be_a Event
        event.persisted?.should be_false
        event.errors.full_messages.should eq {}

        events_list.count.should eq 0
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
  end

  describe '#events_list' do
    def check_event_hash(element, original_event)
      element.delete(:start).nil?.should be_false
      element.delete(:end).nil?.should be_false
      element.should == { title: original_event.title, url: "/mechanics/events/#{original_event.id}", id: original_event.id, className: original_event.job ? 'work' : 'day-off' }
    end

    context 'single unrepeated event' do
      let!(:original_event) { create :event, mechanic: mechanic }

      it 'should return array with single element which is hash with correct format' do
        list = events_manager.events_list
        list.length.should be 1
        element = list[0]
        element.is_a?(Hash).should be_true
        check_event_hash element, original_event
      end
    end

    context 'single repeated event' do
      let!(:original_event) { create :event, :weekly, mechanic: mechanic }

      it do
        list = events_manager.events_list
        list.length.should > 50
        (element = list.sample).is_a?(Hash).should be_true
        check_event_hash element, original_event
      end
    end

    context 'repeated and unrepeated events' do
      let!(:unrepeated_event) { create :event, mechanic: mechanic }
      let!(:repeated_event) { create :event, :weekly, mechanic: mechanic }

      it do
        list = events_manager.events_list
        list.length.should > 50
        (first_element = list.shift).is_a?(Hash).should be_true
        check_event_hash first_element, unrepeated_event

        (element = list.sample).is_a?(Hash).should be_true
        check_event_hash element, repeated_event
      end
    end

    specify 'start/end time' do
      create(:event, mechanic: mechanic, date_start: Date.parse('2012-06-08'), time_start: Time.parse('11:00 GMT'), time_end: Time.parse('15:00 GMT'))
      events_manager.events_list.last[:start].to_s(:db).should eq '2012-06-08 11:00:00'
      events_manager.events_list.last[:end].to_s(:db).should eq '2012-06-08 15:00:00'
    end
  end

  describe '#check_uniqueness', pending: 'this validation is turned off for now as recurring events can intersect in various ways' do
    let(:today)  { Date.today }
    let(:events) { [
      build(:event, :weekly, mechanic: mechanic),
      build(:event, :monthly, mechanic: mechanic, time_start: today + 7.hour, time_end: today + 9.hour),
      build(:event, mechanic: mechanic),
      build(:event, mechanic: mechanic, time_start: today + 7.hour, time_end: today + 11.hour)
    ] }


    context 'false if not unique' do
      before { events.map &:save }

      it { events.each { |e| events_manager.check_uniqueness(e.dup).should be_false } }
    end

    context 'true if unique' do
      it { events.each { |e| events_manager.check_uniqueness(e.dup).should be_true } }
    end

    specify 'not unique if different date_start, but same recurrence and another settings' do
      event = create(:event, :weekly, mechanic: mechanic).dup
      event.date_start += 7.day
      events_manager.check_uniqueness(event).should be_false
    end
  end

  describe '#available_at?' do
    it 'is available' do
      events_manager.available_at?(Date.tomorrow.in_time_zone.to_s).should be_true
    end

    it 'is unavailable' do
      create :event, :whole_day, mechanic: mechanic, date_start: Date.tomorrow
      events_manager.available_at?(Date.tomorrow.to_s).should be_false
    end
  end

  describe '#get_time_start_and_end' do
    let(:today) { Date.today }
    let(:today_time) { today.in_time_zone }
    let(:event) { build :event, :whole_day, date_start: today }

    it 'should return real start and end time if their are exists and occurrence not given' do
      event.time_start = today + 11.hour
      event.time_end = today + 13.hour
      events_manager.get_time_start_and_end(event).should be_eql [event.time_start, event.time_end]
    end

    it 'should create start and end time for occurrence date if it is exists' do
      tomorrow = Date.tomorrow
      occurrence = tomorrow
      event.time_start = today + 11.hour
      event.time_end = today + 13.hour
      events_manager.get_time_start_and_end(event, occurrence).should be_eql [tomorrow + 11.hour, tomorrow + 13.hour]
    end
  end
end
