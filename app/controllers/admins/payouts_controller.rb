class Admins::PayoutsController < Admins::ApplicationController
  include AdminHelper

  before_filter :find_job

  def create
    record_payout
  end

  def update
    record_payout
  end


  private

  def find_job
    @job = Job.find(permitted_params[:job_id])
  end

  def record_payout
    redirect_to edit_admins_job_path(@job) unless @job.mechanic

    payout_service = PayoutService.new(@job.mechanic, @job)
    @payout = payout_service.record_payout(permitted_params)
    if @payout.valid?
      flash[:notice] = 'Payout succesfully saved'
      redirect_to edit_admins_job_path(@job)
    else
      prepare_job_edit
      flash[:error] = 'Error saving payout'
      render '/admins/jobs/edit'
    end
  end

  def permitted_params
    params.require(:payout).permit(:id, :job_id, :account_name, :account_number, :bsb_number, :transaction_id, :amount)
  end
end