class Admin::ModelVariationsController < Admin::ApplicationController

  def index
    @model_variations = ModelVariation.search(search_params).page(params[:page])
    @model_variation = ModelVariation.new(search_params)
  end

  private

  def search_params
    params.fetch(:model_variation, {})
      .permit(:make_id, :model_id, :body_type_id, :from_year, :to_year, :transmission, :fuel)
      .reject { |k, v| v.blank? }
  end
end
