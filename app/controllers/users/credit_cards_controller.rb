class Users::CreditCardsController < Users::ApplicationController

  layout 'application'

  before_filter :verify_appointment

  def new
  end

  def create
    payment_verified = PaymentService.new.verify_card(current_user, @job, credit_card_params)

    if payment_verified && appointment_service.call
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

  def appointment_service
    @job = current_user.estimated_jobs.find(params[:job_id])
    @scheduled_at = appointment_params[:scheduled_at].in_time_zone
    @mechanic = Mechanic.find(appointment_params[:mechanic_id])
    Appointments::Book.new(@job, @mechanic, @scheduled_at)
  end

  def verify_appointment
    unless appointment_params && appointment_service.valid?
      redirect_to edit_users_appointment_path(params[:job_id])
      false
    end
  end
end
