class Admins::RatingsController < Admins::ApplicationController

  before_filter :find_rating, only: [:edit, :update]

  def index
    @query    = params[:query]
    @ratings  = Rating.page(params[:page])
    @ratings  = @ratings.fuzzy_search(@query) unless @query.blank?
  end

  def edit
  end

  def update
    if rating_service.call(permitted_params)
      redirect_to admins_ratings_path, notice: 'Rating updated successfuly'
    else
      render :edit
    end
  end


  private

  def find_rating
    @rating = Rating.find(params[:id])
  end

  def rating_service
    Ratings::Update.new(@rating)
  end

  def permitted_params
    params.require(:rating).permit(
      :id, :professional, :service_quality, :communication, :cleanness,
      :convenience, :comment, :recommend, :published
    )
  end
end
