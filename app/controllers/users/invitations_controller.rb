class Users::InvitationsController < Users::ApplicationController
  skip_before_filter :authenticate_user!, only: [:detect]

  def detect
    if params[:referral_code]
      user = User.find_by(referral_code: params[:referral_code])
      session[:referred_by] = user.id if user
    end

    redirect_to root_path
  end
end
