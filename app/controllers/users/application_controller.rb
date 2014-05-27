class Users::ApplicationController < ApplicationController

  layout 'sidebar'

  before_filter :store_location, unless: :user_signed_in?
  before_filter :authenticate_user!
  before_filter :check_email_confirmed

  private

  def store_location
    session[:previous_url] = request.url if request.get?
  end

  def check_email_confirmed
    if current_user && !current_user.confirmed?
      email = view_context.content_tag :strong, current_user.email
      url   = user_confirmation_path(user: { email: current_user.email })
      resend_link = view_context.link_to 'Resend instructions', url, method: :post, class: 'pull-right'
      flash[:notice] = "Please confirm your email address. A confirmation email was sent to #{email}. #{resend_link}".html_safe
    end
  end
end
