class Users::JobsController < Users::ApplicationController

  layout 'application'

  respond_to :json

  skip_before_filter :authenticate_user!, only: [:service, :repair, :create]

  def service
    @mode = 'service'
    render_wizard
  end

  def repair
    @mode = 'repair'
    render_wizard
  end

  def show
    respond_with current_user.jobs.find(params[:id])
  end

  def create
    job = job_service.create_job
    session[:tmp_job_id] = job.id unless user_signed_in?

    respond_with job, location: false
  end


  private

  def render_wizard
    @job = Job.new
    @user_id = false
    @cars = []
    @location = @job.build_location
    @contact = {}
    @symptoms = Symptom.json_tree

    if user_signed_in?
      @user_id = current_user.id
      @cars = current_user.cars.select([:id, :display_title, :model_variation_id]).to_json
      @location = current_user.location
      @contact = { contact_email: current_user.email, contact_phone: current_user.mobile_number }

      job_id = session.delete(:tmp_job_id)
      @job = job_service.convert_from_temporary(job_id) if job_id
    end

    render 'wizard'
  end

  def job_service
    @job_service ||= UserCreateJobService.new(current_user, params)
  end

  def states_json
    State.select([:id, :name]).to_json
  end
  helper_method :states_json
end
