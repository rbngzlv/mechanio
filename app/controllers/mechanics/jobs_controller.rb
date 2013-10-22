class Mechanics::JobsController < Mechanics::ApplicationController
  def index
  end

  def show
    @job = current_mechanic.jobs.find(params[:id])
  end
end
