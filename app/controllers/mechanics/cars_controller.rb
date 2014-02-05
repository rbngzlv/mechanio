class Mechanics::CarsController < Mechanics::ApplicationController
  before_filter :find_job

  def update
    car_params = params.require(:car).permit(:vin, :reg_number)
    if @job.car.update_attributes car_params
      redirect_to mechanics_job_path(@job), notice: 'Car details successfully updated'
    else
      render 'mechanics/jobs/show'
    end
  end

  private

  def find_job
    @job = current_mechanic.appointments.find(params[:job_id])
  end
end
