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
      element.should == { title: original_event.title, url: "/mechanics/events/#{original_event.id}", id: original_event.id }
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
end
