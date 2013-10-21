require 'spec_helper'

describe Repair do

  let(:repair) { create :repair }

  it { should have_and_belong_to_many :symptoms }

  it 'sums items costs on save', :pending do
  end
end
