class Users::AppointmentsController < Users::ApplicationController
  before_filter :find_job, only: [:edit, :update]

  layout :select_layout

  def index
    @appointments = current_user.appointments
    @past_appointments = current_user.past_appointments
  end

  def edit
  end

  def update
    mechanic = mechanics.find(appointment_params[:mechanic_id])
    appointment_service = AppointmentService.new(@job, mechanic, appointment_params[:scheduled_at])

    if appointment_service.valid?
      session[:appointment_params] = appointment_params
      redirect_to new_users_job_credit_card_path(@job)
    else
      flash[:error] = appointment_service.errors.full_messages.join("\n")
      render :edit
    end
  end

  private

  def appointment_params
    params.require(:job).permit(:scheduled_at, :mechanic_id)
  end

  def mechanics
    Mechanic.active.by_region(@job.location_postcode)
  end
  helper_method :mechanics

  def find_job
    @job = current_user.estimates.find(params[:id])
  end

  def select_layout
    action_name == 'index' ? 'sidebar' : 'application'
  end
end
