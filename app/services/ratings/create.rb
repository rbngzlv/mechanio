class Ratings::Create

  def initialize(user, job)
    @user     = user
    @job      = job
    @mechanic = @job.mechanic
  end

  def call(attrs)
    return false if @job.rating.present?

    rating = Rating.new(attrs)
    rating.user       = @user
    rating.job        = @job
    rating.mechanic   = @mechanic
    rating.published  = true

    if rating.save
      @mechanic.update_rating
      rating
    else
      false
    end
  end
end
