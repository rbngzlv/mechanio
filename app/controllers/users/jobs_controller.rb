class Users::JobsController < Users::ApplicationController

  layout 'application'

  respond_to :json

  skip_before_filter :authenticate_user!, only: [:new, :create]

  def new
    @job = Job.new
    @user_id = false
    @cars = []

    if user_signed_in?
      @user_id = current_user.id
      @cars = current_user.cars.select([:id, :display_title, :model_variation_id]).to_json

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
      if job = Job.create_temporary(params)
        session[:tmp_job_id] = job.id
      end
    end

    respond_with job, location: false
  end

  private

  def states_json
    State.select([:id, :name]).to_json
  end
  helper_method :states_json
end
