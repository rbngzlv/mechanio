class Users::JobsController < Users::ApplicationController

  layout 'application'

  respond_to :json

  skip_before_filter :authenticate_user!, except: [:create_temporary]

  def new
    @job = Job.new
    @user_id = false
    @cars = []

    if user_signed_in?
      @user_id = current_user.id
      @cars = current_user.cars.select([:id, :display_title, :model_variation_id]).to_json
    end
  end

  def create_temporary
    respond_with Job.create_temporary(params)
  end

  def create
    respond_with current_user.jobs.create!(permitted_params), location: false
  end

  private

  def permitted_params
    params.require(:job).permit(
      :car_id, :contact_email, :contact_phone,
      location_attributes:  [:address, :suburb, :postcode, :state_id],
      car_attributes:       [:year, :model_variation_id],
      tasks_attributes:     [:type, :service_plan_id, :note]
    )
  end
end
