class Ratings::Update

  def initialize(rating)
    @rating = rating
  end

  def call(params)
    rating = Rating.find(params[:id])

    if rating.update(params)
      rating.mechanic.update_rating
      true
    else
      false
    end
  end
end
