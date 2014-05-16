class Users::RatingsController < ApplicationController

  def create
    unless rating = rating_service.call(rating_params)
      flash[:error] = 'Error saving feedback'
    end

    redirect_to users_appointment_path(params[:appointment_id])
  end


  private

  def rating_params
    params.require(:rating).permit(:professional, :service_quality, :communication, :cleanness, :convenience, :comment, :recommend)
  end

  def rating_service
    Ratings::Create.new(current_user, job)
  end

  def job
    current_user.past_jobs.find(params[:appointment_id])
  end
end
