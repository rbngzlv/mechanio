class Admins::ModelVariationsController < Admins::ApplicationController

  def index
    @model_variations = ModelVariation.search(search_params).page(params[:page])
    @model_variation = ModelVariation.new(search_params)
    @models = @model_variation.make ? @model_variation.make.models : []
  end

  private

  def search_params
    params.fetch(:model_variation, {})
      .permit(:make_id, :model_id, :shape, :from_year, :to_year, :transmission, :fuel)
      .reject { |k, v| v.blank? }
  end
end
