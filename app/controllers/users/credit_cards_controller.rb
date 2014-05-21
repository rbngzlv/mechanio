class Users::CreditCardsController < Users::ApplicationController

  layout 'application'

  before_filter :verify_appointment

  def new
  end

  def create
    payment_verified = PaymentService.new.verify_card(current_user, @job, credit_card_params)

    if payment_verified && appointment.book_appointment
      session.delete(:appointment_params)
      session[:just_booked] = true
      redirect_to users_appointments_path
    else
      @error = true
      render :new
    end
  end


  private

  def credit_card_params
    params.require(:credit_card).permit(:cardholder_name, :number, :cvv, :expiration_month, :expiration_year)
  end

  def appointment_params
    session[:appointment_params]
  end

  def appointment
    @job = current_user.estimated_jobs.find(params[:job_id])
    @scheduled_at = appointment_params[:scheduled_at].to_time
    @mechanic = Mechanic.find(appointment_params[:mechanic_id])
    AppointmentService.new(@job, @mechanic, @scheduled_at)
  end

  def verify_appointment
    unless appointment_params && appointment.valid?
      redirect_to edit_users_appointment_path(params[:job_id])
      false
    end
  end
end
