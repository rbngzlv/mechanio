class Admins::AppointmentsController < Admins::ApplicationController
  include AdminHelper

  before_filter :find_job, only: [:edit, :update]

  def edit
    @mechanic = @job.mechanic
  end

  def update
    service = Appointments::Reschedule.new(@job, permitted_params[:scheduled_at])

    unless service.call
      flash[:error] = 'Error rescheduling appointment'
    end

    redirect_to edit_admins_job_path(@job)
  end


  private

  def find_job
    @job = Job.assigned.find(params[:id])
  end

  def permitted_params
    params.require(:job).permit(:scheduled_at)
  end
end
