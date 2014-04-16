class RatingService

  def initialize(user, job)
    @user     = user
    @job      = job
    @mechanic = @job.mechanic
  end

  def rate(attrs)
    rating = Rating.new(attrs)
    rating.user     = @user
    rating.job      = @job
    rating.mechanic = @mechanic

    if rating.save
      @mechanic.update_attribute(:rating, mechanic_rating)
      rating
    else
      false
    end
  end


  private

  def mechanic_rating
    ratings = @mechanic.ratings.map { |r| r.average }
    @mechanic.ratings.any? ? ratings.sum.to_f / @mechanic.ratings.size : 0
  end
end
