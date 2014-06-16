module EmailConfirmationHelper
  def show_email_confirmation_alert?
    controllers = %w(dashboard cars appointments estimates profiles settings).map { |c| "users/#{c}" }
    show = controllers.include?(params[:controller])
    show = false if params[:controller] == 'users/appointments' && params[:action] != 'index'
    show = show && current_user && !current_user.confirmed?
  end

  def email_confirmation_alert(email)
    email_tag = content_tag :strong, email
    resend_link = link_to 'Resend instructions', user_confirmation_path(user: { email: email }), method: :post, class: 'pull-right'
    "Please confirm your email address. A confirmation email was sent to #{email_tag}. #{resend_link}".html_safe
  end
end
