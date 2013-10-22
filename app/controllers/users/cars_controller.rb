class Users::CarsController < Users::ApplicationController
  def index
    @cars = current_user.cars
  end
end
