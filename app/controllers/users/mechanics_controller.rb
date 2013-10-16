class Users::MechanicsController < Users::ApplicationController
  before_filter :current_job

  layout "application"

  def edit
    @mechanics = Mechanic.all
  end

  def update
    if @job.update_attributes params[:job].permit(:date, :mechanic_id)
      @job.set_status_assigned
      redirect_to users_appointments_path, notice: 'Mechanic succesfully assigned.'
    else
      render :edit
    end
  end

  private

  def current_job
    @job ||= current_user.jobs.find(params[:job_id])
  end
end
