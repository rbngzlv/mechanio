require 'spec_helper'

describe Part do

  it { should have_one :task_item }

  it { should validate_presence_of :name }
  it { should validate_presence_of :cost }
  it { should validate_presence_of :quantity }
end
