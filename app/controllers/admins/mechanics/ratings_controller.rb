class Admins::Mechanics::RatingsController < Admins::ApplicationController
  before_filter :find_mechanic

  def index
    @ratings = @mechanic.ratings
  end

  def edit
    session[:return_to] = admins_mechanic_ratings_path(@mechanic)
    @rating = @mechanic.ratings.find(params[:id])
  end


  private

  def find_mechanic
    @mechanic = Mechanic.find(params[:mechanic_id])
  end
end
