require 'spec_helper'

describe FixedAmount do

  it { should belong_to :task }

  it { should validate_presence_of :task }
  it { should validate_presence_of :description }
  it { should validate_presence_of :cost }
end
