class Users::DashboardController < Users::ApplicationController

  def index
    @appointment = current_user.appointments.first
    @estimate = current_user.estimates.first
  end
end
