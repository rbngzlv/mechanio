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
    job = Jobs::Create.new.call(current_user, params)
    session[:tmp_job_id] = job.id unless user_signed_in?

    respond_with job, location: false
  end


  private

  def render_wizard
    @job = Job.new
    @user_id = false
    @cars = []
    location = @job.build_location
    @contact = {}
    @symptoms = Symptom.json_tree

    @from_year = ModelVariation.minimum(:from_year)
    @to_year   = ModelVariation.maximum(:to_year)

    if user_signed_in?
      @user_id = current_user.id
      @cars = current_user.cars.select([:id, :display_title, :model_variation_id]).to_json
      location = current_user.location
      @contact = { contact_email: current_user.email, contact_phone: current_user.mobile_number }

      job_id = session.delete(:tmp_job_id)
      @job = Jobs::Convert.new.call(job_id, current_user) if job_id
    end

    @location_json = location.to_json(only: [:id, :address, :postcode, :state_id, :city, :suburb_id], include: {
      suburb: { only: [:id, :name] }
    })

    render 'wizard'
  end

  def states_json
    State.select([:id, :name]).to_json
  end
  helper_method :states_json
end
