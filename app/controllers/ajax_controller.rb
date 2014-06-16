class AjaxController < ApplicationController

  respond_to :html, :json

  def makes
    respond_with ModelsFilter.find(Make, search_params).as_json(only: [:id, :name])
  end

  def models
    respond_with ModelsFilter.find(Model, search_params).as_json(only: [:id, :name])
  end

  def model_variations
    respond_with ModelsFilter.find(ModelVariation, search_params)
      .as_json(only: [:id, :display_title, :detailed_title], methods: [:title_with_year])
  end

  def service_plans
    respond_with ServicePlan.to_options(params.permit(:model_variation_id))
  end

  def suburbs
    respond_with Region.suburbs.search(params[:name]).as_json(only: [:id, :display_name])
  end


  private

  def search_params
    params.permit(:year, :make_id, :model_id)
  end
end
