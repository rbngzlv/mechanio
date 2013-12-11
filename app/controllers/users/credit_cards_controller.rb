class Users::CreditCardsController < Users::ApplicationController

  layout 'application'

  before_filter :find_job

  def new
  end

  def create
    credit_card_params = params.require(:credit_card).permit(:cardholder_name, :number, :cvv, :expiration_date)
    if payment_service.verify_card(current_user, @job, credit_card_params)
      redirect_to users_appointments_path, notice: 'Payment method verified'
    else
      @error = true
      render :new
    end
  end

  private

  def find_job
    @job = current_user.jobs.assigned.find(params[:job_id])
    @mechanic = @job.mechanic
  end

  def payment_service
    PaymentService.new
  end
end
