class Users::EstimatesController < Users::ApplicationController
  def index
    @jobs = current_user.pending_and_estimated
  end
end
