require 'spec_helper'

describe ModelVariation do

  let(:model_variation) { build :model_variation, make: make }
  let(:make)            { build :make, name: 'Volkswagen' }

  it { should belong_to :make }
  it { should belong_to :model }

  it { should validate_presence_of :title }
  it { should validate_presence_of :identifier }
  it { should validate_presence_of :make }
  it { should validate_presence_of :model }
  it { should validate_presence_of :from_year }
  it { should validate_presence_of :to_year }
  it { should validate_presence_of :transmission }
  it { should validate_presence_of :fuel }
  it { should ensure_inclusion_of(:transmission).in_array(ModelVariation::TRANSMISSION)}
  it { should ensure_inclusion_of(:fuel).in_array(ModelVariation::FUEL)}

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

  describe '#set_titles' do
    before do
      model_variation.display_title.should eq nil
      model_variation.detailed_title.should eq nil
    end

    it 'sets titles on save' do
      model_variation.save
      model_variation.display_title.should  eq 'Volkswagen Golf 2.0 Litre 9C SOHC'
      model_variation.detailed_title.should eq '2.0 Litre 9C SOHC Sedan Manual Petrol'
    end

    it 'sets titles without body name' do
      model_variation.shape = nil
      model_variation.save
      model_variation.display_title.should  eq 'Volkswagen Golf 2.0 Litre 9C SOHC'
      model_variation.detailed_title.should eq '2.0 Litre 9C SOHC Manual Petrol'
    end
  end

  it '#search' do
    vw   = create :make, name: 'Volkswagen'
    audi = create :make, name: 'Audi'
    variation1 = create :model_variation, from_year: 2005, to_year: 2007, fuel: 'Petrol', transmission: 'Manual', make: vw, shape: 'Sedan'
    variation2 = create :model_variation, from_year: 2007, to_year: 2010, fuel: 'Diesel', transmission: 'Automatic', make: audi, shape: 'Utility'

    ModelVariation.search(make_id: variation1.make_id).should eq [variation1]
    ModelVariation.search(model_id: variation2.model_id).should eq [variation2]
    ModelVariation.search(from_year: 2006).should eq [variation2]
    ModelVariation.search(from_year: 2005, to_year: 2011).should eq [variation2, variation1]
    ModelVariation.search(to_year: 2009).should eq [variation1]
    ModelVariation.search(transmission: 'Manual').should eq [variation1]
    ModelVariation.search(fuel: 'Diesel').should eq [variation2]
    ModelVariation.search(shape: 'Sedan').should eq [variation1]
  end
end
