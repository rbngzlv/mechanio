class Mechanics::JobsController < Mechanics::ApplicationController
  def index
    @upcoming_jobs = current_mechanic.appointments
    @completed_jobs = current_mechanic.past_appointments
  end

  def show
    @job = current_mechanic.jobs.find(params[:id])
  end

  def cancel
    @job = current_mechanic.appointments.find(params[:id])
    if @job.update_attributes(job_attrs) && @job.cancel
      redirect_to mechanics_jobs_path, notice: 'Job cancelled successfully'
    else
      flash[:error] = 'Please, contact us if you see this message.'
      render :show
    end
  end

  private

  def job_attrs
    params.require(:job).permit(:reason_for_cancel)
  end
end
