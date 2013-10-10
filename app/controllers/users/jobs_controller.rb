class Users::JobsController < Users::ApplicationController

  layout 'application'

  respond_to :json

  skip_before_filter :authenticate_user!, only: [:new, :create]

  def new
    @job = Job.new
    @user_id = false
    @cars = []
    @states = State.select([:id, :name]).to_json

    if user_signed_in?
      @user_id = current_user.id
      @cars = current_user.cars.select([:id, :display_title, :model_variation_id]).to_json

      if session[:tmp_job_id]
        @job = Job.find(session.delete(:tmp_job_id))
        @job.status = :pending
        @job.user_id = current_user.id
        @job.update_attributes(whitelist(job: @job.serialized_params))
      end
    end
  end

  def show
    job = current_user.jobs.includes(:car, :tasks).find(params[:id])
    respond_with job.to_json(only: [:id, :cost], include: {
      car: { only: [:display_title] },
      tasks: { only: [:title] },
      location: { only: [:address, :suburb, :postcode], methods: [:state_name] }
    })
  end

  def create
    if user_signed_in?
      job = current_user.jobs.create!(whitelist(params))
    else
      if job = Job.create_temporary(whitelist(params))
        session[:tmp_job_id] = job.id
      end
    end

    respond_with job, location: false
  end

  private

  def whitelist(params)
    params = ActionController::Parameters.new(params) unless params.is_a?(ActionController::Parameters)
    params.require(:job).permit(
      :car_id, :contact_email, :contact_phone,
      location_attributes:  [:address, :suburb, :postcode, :state_id],
      car_attributes:       [:year, :model_variation_id],
      tasks_attributes:     [:type, :service_plan_id, :note]
    )
  end
end
