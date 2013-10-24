class Mechanics::JobsController < Mechanics::ApplicationController
  def index
    @upcoming_jobs = current_mechanic.jobs.upcoming
    @completed_jobs = current_mechanic.jobs.past
  end

  def show
    @job = current_mechanic.jobs.find(params[:id])
  end
end
