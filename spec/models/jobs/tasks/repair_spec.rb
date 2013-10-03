require 'spec_helper'

describe Repair do

  it { should have_and_belong_to_many :symptoms }
end
