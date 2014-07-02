class Admins::PayoutsController < Admins::ApplicationController
  include AdminHelper

  before_filter :find_job, only: [:create, :update]

  def create
    record_payout
  end

  def update
    record_payout
  end

  def receipt
    payout = Payout.find(params[:id])
    send_file payout.receipt.path
  end


  private

  def find_job
    @job = Job.charged.find(permitted_params[:job_id])
  end

  def record_payout
    payout_service = PayoutService.new(@job.mechanic, @job)
    @payout = payout_service.record_payout(permitted_params)

    if @payout.valid?
      flash[:notice] = 'Payout successfully saved'
      redirect_to edit_admins_job_path(@job)
    else
      prepare_job_edit
      render '/admins/jobs/edit'
    end
  end

  def permitted_params
    params.require(:payout).permit(:id, :job_id, :account_name, :account_number, :bsb_number, :transaction_id, :amount, :receipt)
  end
end