class Users::EstimatesController < Users::ApplicationController
  def index
    @jobs = current_user.estimates
  end
end
