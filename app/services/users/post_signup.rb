module Users
  class PostSignup
    def initialize(user, session)
      @user = user
      @session = session
    end

    def call
      get_location_from_job
      get_referrer

      @user.save
    end

    def get_location_from_job
      if @session[:tmp_job_id]
        attrs = Job.get_location_from_temporary(@session[:tmp_job_id]) || {}
        attrs = ActionController::Parameters.new(attrs).permit(:address, :suburb_id)
        @user.build_location(attrs)
      end
    end

    def get_referrer
      @user[:referred_by] = @session[:referred_by]
    end
  end
end
