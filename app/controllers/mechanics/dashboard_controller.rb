class Mechanics::DashboardController < Mechanics::ApplicationController

  def index
    @jobs = current_mechanic.jobs
  end
end
