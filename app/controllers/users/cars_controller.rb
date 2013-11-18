class Users::CarsController < Users::ApplicationController
  def index
    @cars = current_user.cars
  end

  def destroy
    unless (car = current_user.cars.find(params[:id])).destroy
      flash[:error] = car.errors.full_messages.join('. ')
    end
    redirect_to users_cars_path
  end
end
