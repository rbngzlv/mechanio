module Users
  class PostSignup
    def initialize(user, session)
      @user = user
      @session = session
    end

    def call
      get_location_from_job
      get_referrer
      associate_invitation

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
      @user[:referred_by] = @session.delete(:referred_by)
    end

    def associate_invitation
      return false if @user.referred_by.nil?

      invitation = @user.referrer.sent_invitations.where(email: @user.email).first_or_create
      invitation.user        = @user
      invitation.accepted_at = Time.zone.now
      invitation.save
    end
  end
end
