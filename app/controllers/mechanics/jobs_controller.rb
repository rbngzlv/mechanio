class Mechanics::JobsController < Mechanics::ApplicationController
  def show
    @job = current_mechanic.jobs.find(params[:id])
  end
end
