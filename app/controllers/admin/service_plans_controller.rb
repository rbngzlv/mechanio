class Admin::ServicePlansController < Admin::ApplicationController

  before_filter :find_service_plan, only: [:edit, :update, :destroy]

  def index_default
    @service_plans = ServicePlan.default
  end

  def index_by_model
    @variation_id = search_params[:model_variation_id]
    @service_plan = ServicePlan.new(search_params)

    if @variation_id
      @variation = ModelVariation.find(@variation_id)
      @service_plans = ServicePlan.where(model_variation_id: @variation_id)
    end
  end

  def new
    @service_plan = ServicePlan.new(model_variation_id: search_params[:model_variation_id])
  end

  def create
    @service_plan = ServicePlan.new(permitted_params)

    if @service_plan.save
      redirect_to redirect_after_save, notice: 'Service plan created succesfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @service_plan.update_attributes(permitted_params)
      redirect_to redirect_after_save, notice: 'Service plan updated succesfully.'
    else
      render :edit
    end
  end

  def destroy
    @service_plan.destroy
    redirect_to admin_service_plans_path, notice: 'Service plan deleted succesfully.'
  end


  private

  def redirect_after_save
    if @service_plan.model_variation
      by_model_admin_service_plans_path(service_plan: {
        make_id: @service_plan.make_id, model_id: @service_plan.model_id, model_variation_id: @service_plan.model_variation_id
      })
    else
      default_admin_service_plans_path
    end
  end

  def find_service_plan
    @service_plan = ServicePlan.find(params[:id])
  end

  def permitted_params
    params.require(:service_plan).permit(
      :title, :kms_travelled, :months, :cost, :model_variation_id, :inclusions, :instructions, :parts, :notes
    )
  end

  def search_params
    params.fetch(:service_plan, {})
      .permit(:make_id, :model_id, :model_variation_id)
      .reject { |k, v| v.blank? }
  end
  helper_method :search_params
end
