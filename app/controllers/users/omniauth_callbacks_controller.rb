class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    auth_with 'gmail'
  end

  def facebook
    auth_with 'facebook'
  end

  private

  def auth_with(provider)
    auth = request.env['omniauth.auth']
    if @auth = Authentication.find_or_create_from_oauth(auth, current_user)
      if @auth.user.persisted?
        if user_signed_in?
          set_flash_message(:success, :add_connection, kind: kind_human(provider))
          redirect_to edit_users_profile_path(anchor: 'social-connections')
        else
          set_flash_message(:notice, :success, kind: kind_human(provider))
          sign_in_and_redirect @auth.user, event: :authentication
        end
      else
        session['devise.oauth_data'] = auth
        redirect_to new_user_registration_url, alert: 'Error occurred'
      end
    else
      set_flash_message(:alert, :already_connected, kind: kind_human(provider))
      redirect_to edit_users_profile_path(anchor: 'social-connections')
    end
  end

  def kind_human(provider)
    case provider
      when 'google_oauth2' then 'Gmail'
      else provider.capitalize
    end
  end
end
