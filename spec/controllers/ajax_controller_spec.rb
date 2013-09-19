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

      get :models, format: :json, arbitrary_key: { make_id: model.make_id }
      response.should be_success
      response.body.should eq [{ value: model.id, label: model.name }].to_json
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

      get :model_variations, format: :json, arbitrary_key: { model_id: variation.model_id }
      response.should be_success
      response.body.should eq [{ value: variation.id, label: variation.display_title }].to_json
    end
  end
end
