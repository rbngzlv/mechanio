require 'spec_helper'

describe Part do

  it { should belong_to :task }

  it { should validate_presence_of :task }
  it { should validate_presence_of :name }
  it { should validate_presence_of :cost }
end
