require 'spec_helper'

describe FixedAmount do

  it { should have_one :task_item }

  it { should validate_presence_of :description }
  it { should validate_presence_of :cost }
end
