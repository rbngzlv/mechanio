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
    if @auth = Authentication.find_or_create_from_oauth(auth, current_user)
      if @auth.user.persisted?
        if user_signed_in?
          flash[:success] = 'Successfully added'
          redirect_to edit_users_profile_path(anchor: 'social-connections')
        else
          set_flash_message(:notice, :success, kind: provider.capitalize)
          sign_in_and_redirect @auth.user, event: :authentication
        end
      else
        session["devise.oauth_data"] = auth
        redirect_to new_user_registration_url, alert: 'Error occurred'
      end
    else
      redirect_to edit_users_profile_path(anchor: 'social-connections'), alert: 'Connection not available'
    end
  end
end
