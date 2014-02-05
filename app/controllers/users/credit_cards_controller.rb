class Users::CreditCardsController < Users::ApplicationController

  layout 'application'

  before_filter :verify_appointment, :find_job

  def new
  end

  def create
    payment_verified = PaymentService.new.verify_card(current_user, @job, credit_card_params)

    if payment_verified && appointment.confirm
      session.delete(:appointment_params)
      redirect_to users_appointments_path, notice: 'Appointment booked'
    else
      @error = true
      render :new
    end
  end


  private

  def credit_card_params
    params.require(:credit_card).permit(:cardholder_name, :number, :cvv, :expiration_date)
  end

  def appointment_params
    session[:appointment_params]
  end

  def appointment
    @appointment ||= AppointmentService.new(@job, appointment_params)
  end

  def verify_appointment
    unless appointment_params
      redirect_to edit_users_appointment_path(params[:job_id])
      return
    end
    @scheduled_at = appointment_params[:scheduled_at].to_time
    @mechanic = Mechanic.find(appointment_params[:mechanic_id])
  end

  def find_job
    @job = current_user.estimates.find(params[:job_id])
  end
end
