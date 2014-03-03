class Admins::Mechanics::JobsController < Admins::ApplicationController

  before_filter :find_mechanic

  def index
    @jobs = @mechanic.jobs
  end


  private

  def find_mechanic
    @mechanic = Mechanic.find(params[:mechanic_id])
  end
end
