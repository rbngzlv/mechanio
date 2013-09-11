require 'spec_helper'

describe ModelVariation do

  let(:model_variation) { build :model_variation }

  it { should belong_to :brand }
  it { should belong_to :model }
  it { should belong_to :body_type }

  it { should validate_presence_of :title }
  it { should validate_presence_of :identifier }
  it { should validate_presence_of :brand_id }
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

  it '#search' do
    variation1 = create :model_variation, from_year: 2005, to_year: 2007, fuel: 'Petrol', transmission: 'Manual'
    variation2 = create :model_variation, from_year: 2007, to_year: 2010, fuel: 'Diesel', transmission: 'Automatic'
    brands = Brand.all.to_a
    models = Model.all.to_a
    ModelVariation.search(brand_id: brands[0].id).should eq [variation1]
    ModelVariation.search(model_id: models[1].id).should eq [variation2]
    ModelVariation.search(from_year: 2006).should eq [variation2]
    ModelVariation.search(from_year: 2005, to_year: 2011).should eq [variation1, variation2]
    ModelVariation.search(to_year: 2009).should eq [variation1]
    ModelVariation.search(transmission: 'Manual').should eq [variation1]
    ModelVariation.search(fuel: 'Diesel').should eq [variation2]
  end
end
