class Mechanics::DashboardController < Mechanics::ApplicationController

  def index
    @upcoming_jobs = current_mechanic.jobs.upcoming
    @completed_jobs = current_mechanic.jobs.past
  end
end
