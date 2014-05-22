class Admins::Mechanics::RatingsController < Admins::ApplicationController
  before_filter :find_mechanic

  def index
    @ratings = @mechanic.ratings
  end

  def edit
    @rating = @mechanic.ratings.find(params[:id])
  end


  private

  def find_mechanic
    @mechanic = Mechanic.find(params[:mechanic_id])
  end
end
