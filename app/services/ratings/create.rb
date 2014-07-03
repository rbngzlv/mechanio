module Ratings
  class Create

    def initialize(user, job)
      @user     = user
      @job      = job
      @mechanic = @job.mechanic
    end

    def call(attrs)
      return false if @job.rating.present?

      rating_attrs = attrs.merge(user_id: @user.id, mechanic_id: @mechanic.id, published: true)
      rating = @job.create_rating(rating_attrs)

      if rating.persisted?
        @mechanic.update_rating
        send_notifications
        rating
      else
        false
      end
    end


    private

    def send_notifications
      AdminMailer.async.job_rated(@job.id)
    end
  end
end
