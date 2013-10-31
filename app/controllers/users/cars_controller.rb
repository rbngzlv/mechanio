class Users::CarsController < Users::ApplicationController
  def index
    @cars = current_user.cars
  end

  def destroy
    current_user.cars.find(params[:id]).destroy
    redirect_to users_cars_path
  end
end
