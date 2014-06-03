class Admins::JobsController < Admins::ApplicationController
  include AdminHelper

  before_filter :find_job, only: [:edit, :update, :destroy]

  def index
    @status = params[:status]
    @jobs = @status.present? ? Job.with_status(@status) : Job.all
    @jobs = @jobs.page(params[:page])
  end

  def edit
    session[:return_to] = edit_admins_job_path(@job)
    prepare_job_edit
  end

  def update
    if update_service.call(@job, params)
      flash[:notice] = 'Job successfully updated'
    else
      flash[:error] = 'Error updating job'
    end
    redirect_to action: :edit
  end

  def destroy
    @job.destroy
    redirect_to admins_jobs_path, notice: 'Job successfully deleted.'
  end


  private

  def find_job
    @job = Job.find(params[:id])
  end

  def update_service
    Jobs::Update.new
  end
end
