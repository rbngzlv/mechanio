class Users::InvitationsController < Users::ApplicationController
  skip_before_filter :authenticate_user!, only: [:detect]

  def detect
    if params[:referrer_code]
      user = User.find_by(referrer_code: params[:referrer_code])
      session[:referred_by] = user.id if user
    end

    redirect_to root_path
  end
end
