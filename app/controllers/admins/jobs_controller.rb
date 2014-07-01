class Admins::JobsController < Admins::ApplicationController
  include AdminHelper

  before_filter :find_job, only: [:edit, :update, :cancel, :select_mechanic, :reassign, :complete, :destroy]

  def index
    @status = params[:status]
    @query = params[:query]

    @jobs = Job.all
    @jobs = @jobs.with_status(@status) if @status.present?
    @jobs = @jobs.search(@query.downcase) if @query.present?

    @jobs = @jobs.includes(:user, :mechanic, location: [:suburb]).page(params[:page])
  end

  def edit
    session[:return_to] = edit_admins_job_path(@job)
    prepare_job_edit
  end

  def update
    if Jobs::Update.new.call(@job, params)
      flash[:notice] = 'Job successfully updated'
    else
      flash[:error] = 'Error updating job'
    end
    redirect_to action: :edit
  end

  def select_mechanic
    @mechanics = Mechanic.active.by_region(@job.location_postcode)
  end

  def reassign
    mechanic = Mechanic.find(reassign_params[:mechanic_id])
    if Appointments::Reassign.new(@job, mechanic, reassign_params[:scheduled_at]).call
      flash[:notice] = 'Job successfully reassigned'
    else
      flash[:error] = 'Error reassigning job'
    end

    redirect_to action: :edit
  end

  def cancel
    if Jobs::Cancel.new(@job).call
      flash[:notice] = 'Job successfully cancelled'
    else
      flash[:alert] = 'Error cancelling job'
    end
    redirect_to action: :edit
  end

  def complete
    if Jobs::Complete.new(@job).call
      flash[:notice] = 'Job successfully completed'
    else
      flash[:alert] = 'Error completing job'
    end
    redirect_to action: :edit
  end

  # def destroy
  #   @job.destroy
  #   redirect_to admins_jobs_path, notice: 'Job successfully deleted.'
  # end


  private

  def find_job
    @job = Job.find(params[:id])
  end

  def reassign_params
    params.require(:job).permit(:mechanic_id, :scheduled_at)
  end
end
