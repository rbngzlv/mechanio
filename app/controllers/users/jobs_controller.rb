class Users::JobsController < Users::ApplicationController

  layout 'application'

  respond_to :json

  skip_before_filter :authenticate_user!, only: [:new, :create]

  def new
    @job = Job.new
    @user_id = false
    @cars = []
    @location = @job.build_location
    @contact = {}

    if user_signed_in?
      @user_id = current_user.id
      @cars = current_user.cars.select([:id, :display_title, :model_variation_id]).to_json
      @location = current_user.location
      @contact = { contact_email: current_user.email, contact_phone: current_user.mobile_number }

      if session[:tmp_job_id]
        @job = Job.convert_from_temporary(session.delete(:tmp_job_id), current_user)
      end
    end
  end

  def show
    respond_with current_user.jobs.find(params[:id])
  end

  def create
    if user_signed_in?
      job = current_user.jobs.sanitize_and_create(params)
    else
      job = Job.create_temporary(params)
      session[:tmp_job_id] = job.id
    end

    respond_with job, location: false
  end

  private

  def symptoms
    Symptom.tree
  end
  helper_method :symptoms

  def states_json
    State.select([:id, :name]).to_json
  end
  helper_method :states_json
end
