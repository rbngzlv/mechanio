require 'spec_helper'

describe Repair do

  let(:repair) { build :repair }
  let(:symptom) { create :symptom }

  it { should have_and_belong_to_many :symptoms }

  it 'sums items costs on save', :pending do
  end

  context 'validates either note or symptoms' do
    before do
      repair.note = nil
      repair.symptom_ids = []
    end

    it 'is invalid when both empty' do
      repair.valid?.should be_false
    end

    it 'is valid when note not empty' do
      repair.note = 'A note'
      repair.valid?.should be_true
    end

    it 'is valid when symptoms not empty' do
      repair.symptom_ids = [symptom.id]
      repair.valid?.should be_true
    end
  end
end
