class Users::DashboardController < Users::ApplicationController

  def index
    @appointment = current_user.current_jobs.first
    @estimate = current_user.estimated_jobs.first
    @outstanding_reviews = current_user.unrated_jobs
  end
end
