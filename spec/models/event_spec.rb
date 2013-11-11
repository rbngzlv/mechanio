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
end
