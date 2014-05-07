require 'spec_helper'

describe Inspection do

  let(:inspection) { build :inspection }

  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
end
