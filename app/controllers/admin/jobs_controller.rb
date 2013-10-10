class Admin::JobsController < Admin::ApplicationController

  def index
    @jobs = Job.page(params[:page])
  end

  def edit
  end

  def update
  end
end
