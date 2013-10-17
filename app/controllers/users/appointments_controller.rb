class Users::AppointmentsController < Users::ApplicationController
  before_filter :find_job, only: [:edit, :update]

  layout :select_layout

  def index
  end

  def edit
    @mechanics = Mechanic.all
  end

  def update
    if @job.assign_mechanic params[:job].permit(:scheduled_at, :mechanic_id)
      redirect_to users_appointments_path, notice: 'Mechanic succesfully assigned.'
    else
      render :edit
    end
  end

  private

  def find_job
    @job = current_user.jobs.estimated.find(params[:id])
  end

  def select_layout
    action_name == 'index' ? 'sidebar' : 'application'
  end
end
