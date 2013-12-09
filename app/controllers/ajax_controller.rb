class AjaxController < ApplicationController

  respond_to :html, :json

  def models
    respond_with Model.to_options(params.permit(:make_id))
  end

  def model_variations
    respond_with ModelVariation.to_options(params.permit(:model_id, :year))
  end

  def service_plans
    respond_with ServicePlan.to_options(params.permit(:model_variation_id))
  end

  def regions
    subtree = Region.find(params[:id]).descendants.arrange
    render text: view_context.nested_groups(subtree)
  end

  def helpers
    ActionController::Base.helpers
  end
end
