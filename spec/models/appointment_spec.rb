require 'spec_helper'

describe Appointment do

  let(:mechanic) { create :mechanic }
  let(:appointment) { create :appointment, scheduled_at: Date.tomorrow, mechanic: mechanic }

  it { should belong_to :user }
  it { should belong_to :mechanic }
  it { should belong_to :job }

  it { should validate_presence_of :user }
  it { should validate_presence_of :mechanic }
  it { should validate_presence_of :job }
  it { should validate_presence_of :scheduled_at }
end
