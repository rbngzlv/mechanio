class Users::JobsController < Users::ApplicationController

  skip_before_filter :authenticate_user!, only: [:new]

  def new
    @job = Job.new
  end

  def create
  end
end
