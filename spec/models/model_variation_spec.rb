require 'spec_helper'

describe ModelVariation do

  let(:model_variation) { build :model_variation }

  it { should belong_to :model }
  it { should belong_to :body_type }

  it { should validate_presence_of :title }
  it { should validate_presence_of :identifier }
  it { should validate_presence_of :model_id }
  it { should validate_presence_of :body_type_id }
  it { should validate_presence_of :from_year }
  it { should validate_presence_of :to_year }
  it { should validate_presence_of :transmission }
  it { should validate_presence_of :fuel }

  context 'validates transmission' do
    ModelVariation::TRANSMISSION.each do |t|
      it { should allow_value(t).for(:transmission) }
    end
    it { should_not allow_value('Invalid').for(:transmission) }
  end

  context 'validates fuel' do
    ModelVariation::FUEL.each do |f|
      it { should allow_value(f).for(:fuel) }
    end
    it { should_not allow_value('Invalid').for(:fuel) }
  end

  it 'validates year range' do
    model_variation.from_year = 123
    model_variation.to_year = 345
    model_variation.valid?.should be_false
    model_variation.errors.messages.should include(from_year: ['is not a valid year'])
    model_variation.errors.messages.should include(to_year: ['is not a valid year'])

    model_variation.from_year = 1980
    model_variation.to_year = 1970
    model_variation.valid?.should be_false

    model_variation.from_year = 1980
    model_variation.to_year = 1995
    model_variation.valid?.should be_true
  end
end
