require 'spec_helper'

describe Repair do

  let(:repair) { build :repair }
  let(:symptom) { create :symptom }

  it { should have_and_belong_to_many :symptoms }
end
