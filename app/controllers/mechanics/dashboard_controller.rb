class Mechanics::DashboardController < Mechanics::ApplicationController

  def index
    @upcoming_jobs = current_mechanic.current_jobs
    @completed_jobs = current_mechanic.past_jobs
  end
end
