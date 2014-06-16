require 'spec_helper'

describe AjaxController do
  let(:vw)    { create :make, name: 'Volkswagen' }
  let(:audi)  { create :make, name: 'Audi' }
  let(:golf)  { create :model, name: 'Golf', make: vw }
  let(:a3)    { create :model, name: 'A3', make: audi }

  let(:vw_golf1) { create :model_variation, make: vw, model: golf, from_year: 2000, to_year: 2005 }
  let(:vw_golf2) { create :model_variation, make: vw, model: golf, from_year: 2000, to_year: 2004 }
  let(:audi_a31) { create :model_variation, make: audi, model: a3, from_year: 1998, to_year: 2000 }
  let(:audi_a32) { create :model_variation, make: audi, model: a3, from_year: 2001, to_year: 2003 }

  context '#GET makes' do
    it 'with empty params' do
      get :makes, format: :json
      response.should be_success
      response.body.should eq '[]'
    end

    it 'by year' do
      vw_golf2
      audi_a31

      get :makes, format: :json, year: 2001

      response.should be_success
      response.body.should eq [{ id: vw.id, name: vw.name }].to_json
    end
  end

  context '#GET models' do
    it 'with empty params' do
      get :models, format: :json
      response.should be_success
      response.body.should eq '[]'
    end

    it 'by make_id' do
      model = create :model

      get :models, format: :json, make_id: model.make_id
      response.should be_success
      response.body.should eq [{ id: model.id, name: model.name }].to_json
    end
  end

  context '#GET model_variations' do
    it 'with empty params' do
      get :model_variations, format: :json
      response.should be_success
      response.body.should eq '[]'
    end

    it 'by make_id' do
      variation = create :model_variation

      get :model_variations, format: :json, model_id: variation.model_id
      response.should be_success
      response.body.should eq [{
        id: variation.id,
        display_title: variation.display_title,
        detailed_title: variation.detailed_title,
        title_with_year: variation.title_with_year
      }].to_json
    end
  end

  context '#GET suburbs' do
    let!(:region) { create :sydney_region }
    let!(:suburb) { create :sydney_suburb }

    it 'with empty params' do
      get :suburbs, format: :json

      response.should be_success
      response.body.should eq '[]'
    end

    it 'by partial suburb name' do
      get :suburbs, format: :json, name: 'Syd'

      response.should be_success
      response.body.should eq [suburb.as_json(only: [:id, :display_name])].to_json
    end
  end
end
