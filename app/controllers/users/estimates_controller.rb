class Users::EstimatesController < Users::ApplicationController
  def index
    @jobs = current_user.pending_and_estimated_jobs
  end

  def destroy
    job = current_user.estimated_jobs.find(params[:id])

    if Estimates::Delete.new(job).call(permitted_params)
      flash[:notice] = 'Estimate deleted'
    else
      flash[:error] = 'Error deleting estimate'
    end

    redirect_to action: :index
  end


  private

  def permitted_params
    params.require(:job).permit(:delete_reason, :delete_reason_other)
  end
end
