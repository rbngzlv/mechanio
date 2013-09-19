class AjaxController < ApplicationController

  respond_to :json

  def models
    respond_with Model.to_options(flat_params.permit(:make_id))
  end

  def model_variations
    respond_with ModelVariation.to_options(flat_params.permit(:model_id))
  end


  private

  def flat_params
    flat = params.values.inject({}) { |m, i| m.merge!(i) if i.is_a?(Hash); m }
    ActionController::Parameters.new(flat)
  end
end
