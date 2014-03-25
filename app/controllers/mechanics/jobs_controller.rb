class Mechanics::JobsController < Mechanics::ApplicationController
  def index
    @upcoming_jobs = current_mechanic.current_jobs
    @completed_jobs = current_mechanic.past_jobs
  end

  def show
    @job = current_mechanic.jobs.find(params[:id])
    render @job.completed? ? :completed_job : :upcoming_job
  end

  def complete
    job = current_mechanic.current_jobs.find(params[:job_id])
    job_service = JobService.new(job)
    job_service.complete

    redirect_to :back
  end
end
