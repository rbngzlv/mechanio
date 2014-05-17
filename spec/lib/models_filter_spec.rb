require 'spec_helper'

describe ModelsFilter do

  let(:vw)    { create :make, name: 'Volkswagen' }
  let(:audi)  { create :make, name: 'Audi' }
  let(:bmw)   { create :make, name: 'BMW' }
  let(:golf)  { create :model, name: 'Golf', make: vw }
  let(:bora)  { create :model, name: 'Bora', make: vw }
  let(:a3)    { create :model, name: 'A3', make: audi }
  let(:m8)    { create :model, name: 'M8', make: bmw }

  let(:vw_golf1) { create :model_variation, make: vw, model: golf, from_year: 2000, to_year: 2005 }
  let(:vw_golf2) { create :model_variation, make: vw, model: golf, from_year: 2000, to_year: 2004 }
  let(:vw_golf3) { create :model_variation, make: vw, model: golf, from_year: 2006, to_year: 2010 }
  let(:vw_bora)  { create :model_variation, make: vw, model: bora, from_year: 2006, to_year: 2010 }
  let(:audi_a31) { create :model_variation, make: audi, model: a3, from_year: 1998, to_year: 2000 }
  let(:audi_a32) { create :model_variation, make: audi, model: a3, from_year: 2001, to_year: 2003 }
  let(:bmw_m8)   { create :model_variation, make: bmw, model: m8, from_year: 1995, to_year: 1997 }

  before do
    vw_golf1; vw_golf2; vw_golf3
    audi_a31; audi_a32
    m8
  end

  it 'filters makes by year' do
    ModelsFilter.find(Make, year: 2006).should eq [vw]
    ModelsFilter.find(Make, year: 2002).should eq [audi, vw]
    ModelsFilter.find(Make, year: 1999).should eq [audi]
    ModelsFilter.find(Make, year: 2012).should eq []
  end

  it 'filters models by year and make' do
    ModelsFilter.find(Model, year: 2006).should eq [golf]
    ModelsFilter.find(Model, year: 2002).should eq [a3, golf]
    ModelsFilter.find(Model, year: 2002, make_id: vw.id).should eq [golf]
    ModelsFilter.find(Model, year: 1999).should eq [a3]
    ModelsFilter.find(Model, year: 2012).should eq []
  end

  it 'filters model variations by year, make and model' do
    ModelsFilter.find(ModelVariation, make_id: vw.id, model_id: golf.id).should eq [vw_golf1, vw_golf2, vw_golf3]
    ModelsFilter.find(ModelVariation, year: 2006, make_id: vw.id, model_id: golf.id).should eq [vw_golf3]
    ModelsFilter.find(ModelVariation, year: 2006, make_id: vw.id).should eq [vw_golf3, vw_bora]
  end
end
