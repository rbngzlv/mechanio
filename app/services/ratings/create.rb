module Ratings
  class Create

    def initialize(user, job)
      @user     = user
      @job      = job
      @mechanic = @job.mechanic
    end

    def call(attrs)
      return false unless @job.completed?

      rating_attrs = attrs.merge(user_id: @user.id, mechanic_id: @mechanic.id, published: true)
      rating = @job.create_rating(rating_attrs)

      if rating.persisted?
        @job.rate!
        @mechanic.update_rating
        rating
      else
        false
      end
    end
  end
end
