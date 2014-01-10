class Admins::JobsController < Admins::ApplicationController

  before_filter :find_job, only: [:edit, :update, :destroy]

  def index
    @jobs = Job.page(params[:page])
  end

  def edit
    @service_plans = @job.car.service_plans
    @service_plans_json = @service_plans.to_json(only: [:id, :cost, :display_title])
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
    redirect_to admins_jobs_path, notice: 'Job succesfully deleted.'
  end


  private

  def find_job
    @job = Job.find(params[:id])
  end

  def permitted_parms
    params.require('job').permit!
  end
end
