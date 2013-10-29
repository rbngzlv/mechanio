require 'spec_helper'

describe AjaxController do

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
end
