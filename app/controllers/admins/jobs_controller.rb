class Admins::JobsController < Admins::ApplicationController
  include AdminHelper

  before_filter :find_job, only: [:edit, :update, :destroy]

  def index
    @status = params[:status]
    @jobs = @status.present? ? Job.with_status(@status) : Job.all
    @jobs = @jobs.page(params[:page])
  end

  def edit
    prepare_job_edit
  end

  def update
    if @job.update_attributes(permitted_parms)
      flash[:notice] = 'Job successfuly updated'
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

  def permitted_parms
    params.require('job').permit!
  end
end
