class Admin::DashboardController < Admin::ApplicationController

  def index
    @users_count = User.count
    @mechanics_count = Mechanic.count
  end
end
