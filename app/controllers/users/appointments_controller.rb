class Users::AppointmentsController < Users::ApplicationController
  before_filter :find_job, only: [:edit, :update]

  layout :select_layout

  def index
    @current_appointments = current_user.jobs.assigned.reorder(:scheduled_at)
  end

  def edit
  end

  def update
    attrs = params.require(:job).permit(:scheduled_at, :mechanic_id)
    if @job.assign_mechanic(attrs)
      redirect_to users_appointments_path, notice: 'Appointment booked'
    else
      flash[:error] = @job.errors[:scheduled_at] == ["can't be blank"] ? 'Choose time slot(s) please.' : @job.errors[:scheduled_at].first
      render :edit
    end
  end

  private

  def mechanics
    Mechanic.by_location(@job.location)
  end
  helper_method :mechanics

  def find_job
    @job = current_user.jobs.estimated.find(params[:id])
  end

  def select_layout
    action_name == 'index' ? 'sidebar' : 'application'
  end
end
