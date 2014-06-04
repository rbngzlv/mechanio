class Mechanics::DashboardController < Mechanics::ApplicationController

  def index
    @upcoming_jobs = current_mechanic.current_jobs.limit(3)
    @completed_jobs = current_mechanic.past_jobs.limit(3)
  end
end
