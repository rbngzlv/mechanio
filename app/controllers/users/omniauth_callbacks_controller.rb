class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    social_auth
  end

  def facebook
    social_auth
  end

  private

  def social_auth
    auth = request.env['omniauth.auth']
    if @auth = Authentication.find_or_create_from_oauth(auth, current_user)
      if @auth.user.persisted?
        if user_signed_in?
          set_flash_message(:success, :add_connection, kind: @auth.provider_name)
          redirect_to edit_users_profile_path(anchor: 'social-connections')
        else
          set_flash_message(:notice, :success, kind: @auth.provider_name)
          sign_in_and_redirect @auth.user, event: :authentication
        end
      else
        session['devise.oauth_data'] = auth
        redirect_to new_user_registration_url, alert: 'Error occurred'
      end
    else
      set_flash_message(:alert, :already_connected, kind: Authentication.provider_name(auth[:provider]))
      redirect_to edit_users_profile_path(anchor: 'social-connections')
    end
  end
end
