class Users::AppointmentsController < Users::ApplicationController
  before_filter :find_job, only: [:edit, :update]

  layout :select_layout

  def index
    @current_appointments = current_user.jobs.assigned
  end

  def edit
  end

  def update
    attrs = params.require(:job).permit(:scheduled_at, :mechanic_id)
    if @job.assign_mechanic(attrs)
      redirect_to users_appointments_path, notice: 'Appointment booked'
    else
      flash[:error] = 'Error assigning mechanic'
      render :edit
    end
  end

  private

  def mechanics
    Mechanic.all
  end
  helper_method :mechanics

  def find_job
    @job = current_user.jobs.estimated.find(params[:id])
  end

  def select_layout
    action_name == 'index' ? 'sidebar' : 'application'
  end
end
