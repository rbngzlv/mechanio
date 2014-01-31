class Users::DashboardController < Users::ApplicationController

  def index
    if @booked_appointment = current_user.jobs.appointments.first
      @booked_appointment_mechanic = @booked_appointment.mechanic
    end
    @last_estimate = current_user.jobs.estimates.first
  end
end
