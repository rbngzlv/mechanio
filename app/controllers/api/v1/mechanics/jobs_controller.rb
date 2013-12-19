class Api::V1::Mechanics::JobsController < Api::ApplicationController

  def index
    respond_with current_mechanic.jobs.upcoming.as_json(format: :list)
  end

  def show
    respond_with current_mechanic.jobs.find(params[:id])
  end
end
