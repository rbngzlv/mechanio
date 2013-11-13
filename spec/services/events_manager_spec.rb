require 'spec_helper'

describe EventsManager do
  let(:mechanic)        { create :mechanic }
  let!(:events_manager)  { EventsManager.new(mechanic) }
  let(:params) do
    ActionController::Parameters.new({
      days_off:     ['Sunday'],
      title:        'Day off',
      mechanic_id:  mechanic,
      recurrence:   :weekly
    })
  end

  describe '#add_events' do
    context 'should add only unique events' do
      it 'returb true if unique' do
        events_manager.add_events(params).should be_true
      end

      it 'returb false if repeated' do
        events_manager.add_events(params.dup).should be_true
        events_manager.add_events(params).should be_false
      end

      context 'it should generate errors if repeated' do
        before do
          events_manager.add_events(params.dup)
          events_manager.add_events(params)
        end

        specify '#events_with_errors' do
          events_manager.events_with_errors.length.should be 1
        end

        specify '#errors_full_message' do
          events_manager.errors_full_message.should be_eql "Sunday is not unique event"
        end
      end
    end
  end

  describe '#events_list' do
    context 'single unrepeated event' do
      before { create :event, mechanic: mechanic }

      it 'should return array with single element which is hash' do
        list = events_manager.events_list
        list.length.should be 1
        hash = list[0]
        hash.is_a?(Hash).should be_true
        should_has_fullcalendar_format hash
      end
    end

    context 'single repeated event' do
      before { create :event, :day_off, mechanic: mechanic }

      it 'should return array with hashes' do
        list = events_manager.events_list
        list.length.should > 50
        (element = list.sample).is_a?(Hash).should be_true
        should_has_fullcalendar_format element
      end
    end

    context 'repeated and unrepeated events' do
      before do
        create :event, :day_off, mechanic: mechanic
        create :event, date_start: Date.tomorrow, mechanic: mechanic
      end

      it 'should return array with hashes' do
        list = events_manager.events_list
        list.length.should > 50
        (element = list.sample).is_a?(Hash).should be_true
        should_has_fullcalendar_format element
      end
    end

    def should_has_fullcalendar_format(hash)
      hash.key?(:start).should be_true
      hash.key?(:title).should be_true
      hash.key?(:url).should be_true
      hash.key?(:id).should be_true
    end
  end

  describe '#check_date' do
    it 'false if not unique' do
      event = create :event, :day_off, mechanic: mechanic
      events_manager.check_date(event.date_start).should be_false
    end

    it 'true if unique' do
      events_manager.check_date(Date.today).should be_true
    end
  end
end
