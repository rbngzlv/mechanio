class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    auth_with 'gmail'
  end

  def facebook
    auth_with 'facebook'
  end

  private

  def auth_with(provider)
    auth = request.env["omniauth.auth"]
    @auth = Authentication.find_or_create_from_oauth(auth)

    if @auth.user.persisted?
      set_flash_message(:notice, :success, kind: provider.capitalize)
      sign_in_and_redirect @auth.user, event: :authentication
    else
      session["devise.oauth_data"] = auth
      redirect_to new_user_registration_url, alert: 'Error occured'
    end
  end
end
