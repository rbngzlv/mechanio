class Mechanics::JobsController < Mechanics::ApplicationController
  def index
    @upcoming_jobs = current_mechanic.appointments
    @completed_jobs = current_mechanic.past_appointments
  end

  def show
    @job = current_mechanic.jobs.find(params[:id])
    render @job.completed? ? :completed_job : :upcoming_job
  end
end
