class Users::AppointmentsController < Users::ApplicationController
  before_filter :find_estimated_job, only: [:edit, :update]
  before_filter :find_completed_job, only: [:show, :receipt]

  layout :select_layout

  def index
    @just_booked  = session.delete(:just_booked)
    @current_jobs = current_user.current_jobs
    @past_jobs    = current_user.past_jobs
  end

  def edit
  end

  def update
    mechanic = mechanics.find(appointment_params[:mechanic_id])
    appointment_service = AppointmentService.new(@job, mechanic, appointment_params[:scheduled_at])

    if appointment_service.valid?
      session[:appointment_params] = appointment_params
      redirect_to new_users_job_credit_card_path(@job)
    else
      flash[:error] = appointment_service.errors.full_messages.join("\n")
      render :edit
    end
  end

  def show
    @show_thankyou_modal = session.delete(:show_thankyou_modal)
  end

  def receipt
    receipt = UsersJobReceipt.new(@job)
    send_data receipt.to_pdf, type: 'application/pdf', disposition: 'inline'
  end

  private

  def appointment_params
    params.require(:job).permit(:scheduled_at, :mechanic_id)
  end

  def mechanics
    Mechanic.active.by_region(@job.location_postcode)
  end
  helper_method :mechanics

  def find_estimated_job
    @job = current_user.estimated_jobs.find(params[:id])
  end

  def find_completed_job
    @job = current_user.past_jobs.find(params[:id])
  end

  def select_layout
    %w(index show).include?(action_name) ? 'sidebar' : 'application'
  end
end
