class Admins::DashboardController < Admins::ApplicationController

  def index
    @users_count = User.count
    @mechanics_count = Mechanic.count
  end
end
