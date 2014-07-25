class Users::InvitationsController < Users::ApplicationController
  include ActionView::Helpers::NumberHelper

  skip_before_filter :authenticate_user!, only: [:detect]

  layout 'no_container'

  def index
    @invitations = current_user.sent_invitations
    @share_link = referrer_users_invitations_url(current_user.referrer_code)
    @discount_amount = number_to_currency(GIVE_GET_DISCOUNT_AMOUNT, precision: 0)

    @credit_earned = @credit_pending = 0
    @invitations.each do |i|
      i.awarded? ? @credit_earned += 20 : @credit_pending += 20
    end
    @credit_earned = number_to_currency(@credit_earned, precision: 0)
    @credit_pending = number_to_currency(@credit_pending, precision: 0)
  end

  def create
    # TODO: move this code to a service class
    emails = params[:invitation][:email].split(/[,\s]+/)
    emails.select! { |e| e.match(/\A(\S+)@(.+)\.(\S+)\z/) }

    if emails.size
      emails.each do |email|
        Invitation.create(sender: current_user, email: email)
        UserMailer.async.invite(current_user.id, email)
      end

      flash[:notice] = 'Invitations sent'
    else
      flash[:error] = 'Error sending invitations'
    end

    redirect_to action: :index
  end

  def detect
    if params[:referrer_code]
      user = User.find_by(referrer_code: params[:referrer_code])
      session[:referred_by] = user.id if user
    end

    redirect_to root_path
  end
end
