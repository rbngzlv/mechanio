require 'spec_helper'

describe ModelVariation do

  let(:model_variation) { build :model_variation }

  it { should belong_to :make }
  it { should belong_to :model }
  it { should belong_to :body_type }

  it { should validate_presence_of :title }
  it { should validate_presence_of :identifier }
  it { should validate_presence_of :make_id }
  it { should validate_presence_of :model_id }
  it { should validate_presence_of :body_type_id }
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

  it 'caches titles on save' do
    model_variation.display_title.should eq nil
    model_variation.detailed_title.should eq nil
    model_variation.save
    model_variation.display_title.should eq "#{model_variation.make.name} Golf 3dr Hatchback 1.6turbo"
    model_variation.detailed_title.should eq '3dr Hatchback 1.6turbo 5dr Hatchback Manual Petrol'
  end

  it '#search' do
    variation1 = create :model_variation, from_year: 2005, to_year: 2007, fuel: 'Petrol', transmission: 'Manual'
    variation2 = create :model_variation, from_year: 2007, to_year: 2010, fuel: 'Diesel', transmission: 'Automatic'
    ModelVariation.search(make_id: variation1.make_id).should eq [variation1]
    ModelVariation.search(model_id: variation2.model_id).should eq [variation2]
    ModelVariation.search(from_year: 2006).should eq [variation2]
    ModelVariation.search(from_year: 2005, to_year: 2011).should eq [variation1, variation2]
    ModelVariation.search(to_year: 2009).should eq [variation1]
    ModelVariation.search(transmission: 'Manual').should eq [variation1]
    ModelVariation.search(fuel: 'Diesel').should eq [variation2]
  end

  it '#to_options' do
    variation = create :model_variation
    result = [{ id: variation.id, display_title: variation.display_title, detailed_title: variation.detailed_title }]
    ModelVariation.to_options(model_id: variation.model_id).to_json.should eq result.to_json
  end
end
