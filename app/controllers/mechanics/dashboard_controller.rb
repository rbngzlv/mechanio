class Mechanics::DashboardController < Mechanics::ApplicationController

  def index
    @upcoming_jobs = current_mechanic.appointments
    @completed_jobs = current_mechanic.past_appointments
  end
end
