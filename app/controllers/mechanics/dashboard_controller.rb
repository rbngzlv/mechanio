class Mechanics::DashboardController < Mechanics::ApplicationController

  def index
    @upcoming_jobs = current_mechanic.jobs.assigned
    @completed_jobs = current_mechanic.jobs.completed
  end
end
