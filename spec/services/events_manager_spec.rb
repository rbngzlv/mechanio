require 'spec_helper'

describe EventsManager do
  let(:mechanic)        { create :mechanic }
  let!(:events_manager)  { EventsManager.new(mechanic) }
  let(:params) do
    ActionController::Parameters.new({
      time_slots:   ['All', ''],
      date_start:   Date.today.to_s,
      recurrence:   "Weekly"
    })
  end

  describe '#add_events' do
    it 'return true if unique and has time_slots' do
      events_manager.add_events(params).should be_true
    end

    context 'return false' do
      specify 'if repeated' do
        events_manager.add_events(params.dup).should be_true
        events_manager.add_events(params).should be_false
      end

      specify 'if time slots do not given' do
        params[:time_slots] = []
        events_manager.add_events(params).should be_false
      end
    end

    it 'should generate error if time slots do not given' do
      params[:time_slots] = []
      events_manager.add_events(params)
      events_manager.errors[:time_slots].length.should be 1
      events_manager.errors_full_message.should include "Choose time slot(s) please."
    end

    context 'it should generate errors if repeated' do
      before do
        events_manager.add_events(params.dup)
        events_manager.add_events(params)
      end

      specify '#errors' do
        events_manager.errors[:uniqueness].length.should be 1
      end

      specify '#errors_full_message' do
        events_manager.errors_full_message.should include "is not unique event"
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
      event = create :event, job: create(:job_with_service, mechanic: mechanic), mechanic: mechanic
      expect {
        events_manager.delete_event(event.id)
      }.to_not change { Event.count }
    end
  end

  describe '#distribute_time_slots' do
    let(:date_start) { Date.today}

    specify 'time slots do not given' do
      events_manager.distribute_time_slots([], date_start).should be_false
    end

    specify '"All"' do
      events_manager.distribute_time_slots(['All'], date_start).should be_eql [nil]
    end

    specify '"All" and something else' do
      events_manager.distribute_time_slots(['All', '7'], date_start).should be_eql [nil]
    end

    specify 'separate time slot' do
      events_manager.distribute_time_slots(['7'], date_start).should be_eql [[date_start + 7.hour, 2]]
    end

    specify 'dual time slot' do
      events_manager.distribute_time_slots(['7', '9'], date_start).should be_eql [[date_start + 7.hour, 4]]
    end

    specify 'two time slots' do
      events_manager.distribute_time_slots(['7', '9', '13'], date_start).should be_eql [[date_start + 7.hour, 4], [date_start + 13.hour, 2]]
    end

    specify 'all time slots' do
      events_manager.distribute_time_slots(['7','9','11','13','15'], date_start).should be_eql [nil]
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

    context 'check time start/end' do
      specify 'whole day' do
        event = create(:event, :whole_day, mechanic: mechanic, date_start: Date.parse('2012-07-04'))
        events_manager.events_list.last[:start].to_s(:db).should eq '2012-07-04 00:00:00'
        events_manager.events_list.last[:end].to_s(:db).should eq '2012-07-04 23:59:00'
      end

      specify 'part of day' do
        create(:event, mechanic: mechanic, date_start: Date.parse('2012-06-08'), time_start: Time.parse('11:00 GMT'), time_end: Time.parse('15:00 GMT'))
        events_manager.events_list.last[:start].to_s(:db).should eq '2012-06-08 11:00:00'
        events_manager.events_list.last[:end].to_s(:db).should eq '2012-06-08 15:00:00'
      end
    end
  end

  describe '#check_uniqueness' do
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
      events_manager.available_at?(Date.tomorrow.to_time.to_s).should be_true
    end

    it 'is unavailable' do
      create :event, :whole_day, mechanic: mechanic, date_start: Date.tomorrow
      events_manager.available_at?(Date.tomorrow.to_s).should be_false
    end
  end

  describe '#get_time_start_and_end' do
    let(:today) { Date.today }
    let(:event) { build :event, :whole_day, date_start: today }

    it 'should create start and end time if their are not exists in event' do
      events_manager.get_time_start_and_end(event).should be_eql [today.to_time, today.to_time.advance(hours: 23, minutes: 59)]
    end

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
