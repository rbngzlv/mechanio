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
    attrs = params.require(:job).permit(:scheduled_at, :mechanic_id)
    if @job.assign_mechanic(attrs)
      redirect_to new_users_job_credit_card_path(@job), notice: 'Appointment booked'
    else
      flash[:error] = @job.errors.full_messages.join(', ')
      render :edit
    end
  end

  private

  def mechanics
    Mechanic.by_region(@job.location_postcode)
  end
  helper_method :mechanics

  def find_job
    @job = current_user.estimates.find(params[:id])
  end

  def select_layout
    action_name == 'index' ? 'sidebar' : 'application'
  end
end
